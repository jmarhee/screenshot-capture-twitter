from instabot import Bot
import os, random

if os.environ.get("SCREEN_SOURCE_IG") is not None:
    SCREEN_SOURCE = os.environ['SCREEN_SOURCE_IG']
else:
    exit(1)

bot = Bot()

instagram = {
	"username": os.environ['instagram_username'],
	"password": os.environ['instagram_password']
}

bot.login(username = instagram["username"], password = instagram["password"])

f_path = SCREEN_SOURCE + "/" + random.choice(os.listdir(SCREEN_SOURCE))

bot.upload_photo(f_path, caption="")

bot.logout()