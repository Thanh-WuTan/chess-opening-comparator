import google.generativeai as genai
import os


#Lên trang Gemini API, tạo API key (free)
os.environ["API_KEY"] = "" #Điền API trong ""
genai.configure(api_key=os.environ["API_KEY"])

# Tạo model = API: gemini-1.5-flash: nhanh mà ngu, gemini-1.5-pro: khôn mà chậm
model = genai.GenerativeModel("gemini-2.0-flash-lite")

#test
#respone = model.generate_content(input("Ask Gemini: "))
#print(respone.text)


#Promt cho AI
system_message1 = """You are a chess expert. When I provide the name of a chess opening (e.g., "Ruy Lopez", "Sicilian Defense", "Queen's Gambit"), return a list of the standard opening moves for that opening in algebraic notation (SAN), formatted as a Python list. Only include the main line moves — no more than the first 10 full moves (20 ply). Do not include comments or variations, just the list. If receiving a message that is not a chess opening, but the most similar opening, return the list of moves for that opening. """

system_message2 = "Ruy Lopez"

system_message3 = "e4 e5 Nf3 Nc6 Bb5"



#Khởi tạo promt
Chat = model.start_chat(
    history=[
        {"role": "user", "parts": system_message1},
        {"role": "model", "parts": "Ok"},
        {"role": "user", "parts": system_message2},
        {"role": "model", "parts": system_message3},
        {"role": "user", "parts": "Hi"},
        {"role": "model", "parts": "Not a chess opening"},
    ]
)

print("Chat started. You can now send messages to the model.")

Chat.send_message("Ruy Lopez")
print(Chat.last.text)

def chat(input_text):
    Chat.send_message(input_text)
    return Chat.last.text
