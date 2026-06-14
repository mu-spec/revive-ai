# SUPER SIMPLE GUIDE - FOR YOU (Windows PC + Codemagic)

Your project is ALREADY on your computer here:
C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai

You do NOT need to download the full project again.
You do NOT need VS Code right now.
We will use Notepad + Command Prompt + Codemagic website.

---

## WHAT YOU MUST DO RIGHT NOW (Only 5 Easy Steps)

### STEP 1: Open Your Project Folder
1. Press the Windows key on your keyboard.
2. Type "File Explorer" and open it.
3. In the address bar at the top, paste this and press Enter:
   C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai
4. Keep this window open.

### STEP 2: Update the Main Files (Use Notepad)
You need to replace 3 main files with the clean versions I gave you in this chat.

For each file:
- Find the file in the folder.
- Right-click the file → Open with → Notepad.
- Delete all old text.
- Paste the new clean text I gave (or ask me for it).
- Click File → Save.
- Close Notepad.

Files to update now:
1. codemagic.yaml   ← (the safe version with only "cp" lines)
2. android/app/build.gradle.kts.fixed
3. android/settings.gradle.kts.fixed

Also replace the icon pictures:
- Go to android/app/src/main/res/
- Replace the ic_launcher.png in all 6 mipmap folders with the clean ones.

If you are stuck on any file, just reply "give me full content for codemagic.yaml" and I will paste it here.

### STEP 3: Push to GitHub using CMD (Most Important Step)
1. Press Windows key.
2. Type "cmd" and open Command Prompt.
3. Copy this whole block and paste it into the black window, then press Enter:

cd "C:\Users\PMLS\Downloads\Ai Photo Enhancer\revive_ai"

git init

git add .

git commit -m "ReviveAI ready for build"

git branch -M main

git remote remove origin

git remote add origin https://github.com/mu-spec/revive-ai.git

git push -u origin main

4. When it asks for username, type: mu-spec
5. When it asks for password, use your GitHub password or a token.

After it finishes, copy everything that appeared in the black window and paste it here in chat.
At the end write: Step 3 done

### STEP 4: Build APK on Codemagic Website
1. Open browser and go to: https://codemagic.io
2. Sign in with GitHub.
3. Click "Add application".
4. Select mu-spec → revive-ai.
5. Click Start new build → main branch → Start build.
6. Wait 10-15 minutes.
7. When finished, download the file named "app-release.apk".

### STEP 5: Install on Phone and Tell Me Result
1. Copy the APK to your phone (CPH2083).
2. Uninstall old ReviveAI from phone.
3. Install the new APK.
4. Open the app and test.

Then reply here and tell me:
- Did the app open when you tapped the icon?
- Was the icon clear or blurred?
- Did photo enhancement work?
- Any error?

---

## RIGHT NOW - START WITH STEP 1 and STEP 3

Do Step 1 (open folder) and Step 3 (CMD push) first.
Then paste the CMD result here.

I will help you one step at a time.
You don't need VS Code or to download anything new.

Just reply with the CMD output after Step 3.
