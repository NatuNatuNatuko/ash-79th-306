#!/usr/bin/env python3
import re

with open('lib/main.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Find and replace the drawer closing section
old_drawer_end = """            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('制作者について'),
              onTap: () {
                Navigator.pop(context);
                _openPage(ProfilePage());
              },
            ),
          ],
        ),
      ),"""

new_drawer_end = """            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('制作者について'),
              onTap: () {
                Navigator.pop(context);
                _openPage(ProfilePage());
              },
            ),
            const Divider(),
            ListTile(
              leading: AuthService.instance.isSignedIn
                  ? const Icon(Icons.logout)
                  : const Icon(Icons.login),
              title: AuthService.instance.isSignedIn
                  ? const Text('ログアウト')
                  : const Text('ログイン'),
              onTap: () async {
                Navigator.pop(context);
                if (AuthService.instance.isSignedIn) {
                  await AuthService.instance.signOut();
                  if (mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ログアウトしました')),
                    );
                  }
                } else {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  if (result == true && mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ログインしました')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),"""

content = content.replace(old_drawer_end, new_drawer_end)

with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print('✓ Login drawer item added')
