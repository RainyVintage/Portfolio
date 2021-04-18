# -*- coding: utf-8 -*-
"""
Created on Fri Oct  9 15:20:35 2020

@author: RainyVintage
"""

from datetime import datetime
import random
import time

def main(): 
    global current_time
    global rebirth
    global name
    global age
    print("""

You mission: Get out of today!

Basic settings:
    
    1. Time and space chaos. Three players in parallel time and space intertwined and met.
    
    2. People who die first will be reborn first, and memory is almost lost after rebirth.

Experiment subject access...\n

No bugs detected...\n

...

""")
    input('<Press any key to continue>\n')
    name= input(prompt = "Now, tell me your name:\n")
    age = input(prompt = "Well, just one more thing, in which 'human' year did you born:\n")
    now = datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    rebirth = -1
    print("You wake up in a strange room, Your mind is very confused. You seem to have a nightmare. \n")
    input('<Press any key to continue>\n')
    print("There is a murderous scene flashing in your memory. It is very real, as if you have experienced it yourself \n")
    input('<Press any key to continue>\n')
    print("You look out the window. It is raining heavily outside. You noticed a big screen in the center of the room., which says \n"
    ,current_time, "72 degrees Fahrenheit, weather: rain \n")
    input('<Press any key to continue>\n')
    print("Although it is raining outside, curiosity drives you to go out and see what's going on outside \n")
    input('<Press any key to continue>\n')
    print("There is a silver sword at the door, it looks sharp, you think it should protect your safety, so you picked it up \n")
    input('<Press any key to continue>\n')
    print("When you walk out of the house, you find yourself in the middle of a wooded forest with a staircase to the sky in the distance which seems unreal. \n")
    stage_1()
    
def stage_1():
    global rebirth
    rebirth +=  1
    if rebirth > 5:
        fail()
    else:
        choice_1()    
        
def choice_1():
    print("You find that there is a sign in front of you with the words: 'Do not look back, keep going!'\n"
              "You have to make a choice. \n")
    print("a) Trust the sign, keep going.\n"
          "b) Wait, Is there anything behind? \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You decide that you should follow the instruction on the sign")
        input('<Press any key to continue>\n')
        choice_2()
    elif choice == "b":
        print("There is a humanoid monster behind you. It is exactly the same as the monster in your dream. \n"
              "You are stunned. The monster quickly approaches you with a dark sword in his hand, and your eyes are black...")
        input('<Press any key to continue>\n')
        death_text()
        stage_1()
    else:
        print("Your memory is so messed up, you can’t make other decisions \m")
        choice_1()
    
def choice_2():
    print("As you continue to move forward, a weird figure appears in front of you, like the monster in your dream, you decide to: \n")
    print("a) Quietly follow the monster. \n"
          "b) Wait, There is no reason to chase him. \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You decide to follow that Weird monster \n")
        input('<Press any key to continue>\n')
        print("The monster seems to have noticed you, but it seems to induce you to follow him. \n")
        input('<Press any key to continue>\n')
        print("'Swish', you heard something flying quickly past your ears, you looked back, but you didn't notice anything unusual, you think you continue to follow the weird person. \n")
        input('<Press any key to continue>\n')
        print("You followed the stranger all the way up the stairs you saw before, and suddenly, he stopped and turned around to look at you.")
        input('<Press any key to continue>\n')
        print("You are scared, but you think you should ask him about the situation. \n")
        input('<Press any key to continue>\n')
        print(f"{name}: Who are you and what do you want to do to me? \n")
        input('<Press any key to continue>\n')
        print("The murderous monster looked very vicious, and he began to yell at some language that you didn't understand. \n"
              "You were so frightened, you took out your silver sword and cut the monster down the stairs.")
        choice_3()
    elif choice == "b":
        print("You are hesitant to follow him to move on, but suddenly, a bottle filled with black liquid bursts on your body, seems to be some dark majic. \n"
              "Then your body quickly begins to rot, you see A monster quickly approaches you, and your eyes are black...")
        input('<Press any key to continue>\n')
        death_text()
        stage_1()
    else:
        print("Your memory is so messed up, you can’t make other decisions \n")
        choice_2()
        
def choice_3():
    print("You continue to walk up the stairs and finally come to a place like a portal, you decide:、\n")
    print("a) Just into the portal! \n"
          "b) Forget it, let's go home. \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You decide to jump into the portal.")
        input('<Press any key to continue>\n')
        print("")
        
        stage_2()
    elif choice == "b":
        print("There is a humanoid monster behind you. It is exactly the same as the monster in your dream. \n"
              "You are stunned. The monster quickly approaches you, and your eyes are black...")
        death_text()
        stage_1()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        choice_1()
    
def stage_2():
    global rebirth
    rebirth += 1
    if rebirth >= 7:
        fail()
    else:
        print("""
        You found a mysterious stone stele that says \n
        "You will always be trapped in this world at this time, \n
        Unless you kill all of yourself" \n
        "Pick up the weapons here, and go for self-salvation."
        """)
        input("<Let's kill 'yourself'>\n")
        print("You picked up the dark sword, dark potion and dark bow in front of the stele.\n")
        input('<Now you are the killer?>\n')
        print("After picking up these weapons, your body has changed!\n")
        input('<Changed?>\n')
        print("You have become a humanoid monster!\n")
        print("You use the power of the monster to fly back to the house where you woke up. \n")
        print("And hide by the side of the house ready to kill the first you\n")
        input('<Time passed by>\n')
        choice_4()        
        
        
def choice_4():
    print("That old 'you' came out of the room and saw the notice at the door, then you decided: \n")        
    print("a) Kill him! Use the dark sword to kill him! \n"
          "b) Forget it, I just wanna follow him \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "b":
        print("You decide to just follow 'yourself'. \n")
        input('<Press any key to continue>\n')
        choice_5()
    elif choice == "a":
        print("You decide to kill 'yourself'. \n")
        kill_rate = random.random()
        if kill_rate <= 0.2:
            kill()
        else:
            print("You failed, the old 'you' follow the instruction on the sign and keep moving forward \n")
            input('<Press any key to continue>\n')
            print("Suddenly, he stopped, he seems to notice something. ")
            choice_5()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        choice_4()

def choice_5():
    print("That'you' Squatt down, seeming to notice something ahead, then you decide: \n")
    print("a) Kill him! Use the dark magic potion\n"
          "b) Forget it, let's go home. \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You throw the dark magic potion to the old 'you' \n")
        input('<Press any key to continue>\n')
        kill_rate = random.random()
        if kill_rate <= 0.2:
            kill()
        else:
            print("The dark potion fly passed by the old 'you', you missed the chance \n")
            choice_6()
    elif choice == "b":
        print("You decide to just follow 'yourself again'. \n")
        input('<Press any key to continue>\n')
        choice_6()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        choice_5()
    
def choice_6():
    print("That'you' follow a a monster who looks the same as you up the stairs. \n")
    input('<Press any key to continue>\n')
    print("They stopped and seemed to be talking.\n")
    input('<Press any key to continue>\n')
    print("The old'you' suddently take out the silver sword and cut the monster down the stairs.   \n")
    input('<Press any key to continue>\n')
    print("Then he continue climbing up to the top the stair \n")
    input('<Press any key to continue>\n')
    print("That'you' is standing in front of the portal, this is your last chance to kill him! \n")
    print("a) Shoot him! Use the dark bowl! \n"
          "b) Let him jump into the portal. \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You decide to shoot the old 'you' with the dark bowl.")
        input('<Press any key to continue>\n')
        kill_rate = random.random()
        if kill_rate <= 0.2:
            kill()
        else:
            truth()
            stage_3()
    elif choice == "b":
        print("You decide to just follow 'yourself again'. \n")
        input('<Press any key to continue>\n')
        truth()
        stage_3()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        choice_6()

def truth():
    print("With him disappearing in the portal, you failed to kill him in time. \n")
    input('<Press any key to continue>\n')
    print("You jump into the portal with him, but this time, you find yourslef in a cave.")
    input('<Press any key to continue>\n')
    print("There are so many messages on the wall which look like written by you. You are shocked \n")
    print("""
                  A woke up
                  C protected A
                  B tried to kill A
                  B tried to poison A
                  A killed C
                  B tried to kill A
                  A found the fake Stele
                  A became monster
                  C woke 
                  B protected C
                  A tried to kill C
                  A tried to poison C
                  C cut B
                  A tired to shoot C
                  C jumped into the portal
                  A falled into the cave
                  C found the fake stele
                  C became the monster
                  A found the timetable in the cave
                  A realized everything is a lie
                  B woke up
                  A died to protect B
                  Untimitedly, How to break this cycle??
                  """)
    input('<What should I do? >\n')
    
def stage_3():
    global rebirth
    if rebirth >= 12:
        fail()
    else:
        print("First, you go back to the door of the house and put up a sign at the door that says 'Don't look back, keep going!' \n")
        input('<Press any key to continue>\n')      
        print("Then, you hide in the distance and try to lure the newly reborned 'you' away from the 'you' who is 'killer' and trails behind. \n")
        input('<Press any key to continue>\n')
        rescue()
        
def choice_7():
    global rebirth
    if rebirth <0:
        choice_secret()
    else:
        print("You try to tell the truth to the 'you' in the past.")
        input('<Press any key to continue>\n')
        print("However, you are surprised to find that what you said turned out to be in a language that you did not understand \n")
        input('<Press any key to continue>\n')
        print("The 'old' you are terrified, He drew the silver sword and cut you down the stairs" )
        input('<Press any key to continue>\n')
        print("You fell from the sky and fell into a big lake")
        input("A lake?")
        input('<Press any key to continue>\n')
        death_text()
        print(f"""
              The Clock stops at {current_time} still.
              Again, I have to make choices. Wait, why would I say 'still' and 'again'? \n""")
        print("Again, you have to make choices. Wait, why would I say again? \n")
        input('<What the hell?>\n')
        rebirth = -99
        stage_1()
        
def choice_secret():   
    input('<Press any key to continue>\n')
    print("You guided the 'old' you to the stair, then you turn back. \n")
    input('<Press any key to continue>\n')
    print("Tell him the truth? Should I? \n")
    print("a) He has to know the truth\n"
          "b) What if I jump into the lake just when he tried to cut me? \n")
    choice = input(prompt = "Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("The 'old' you are terrified, He drew the silver sword and cut you down the stairs" )
        input('<Press any key to continue>\n')
        print("You fell from the sky and fell into a big lake")
        input("A lake?")
        input('<Press any key to continue>\n')
        death_text()
        print(f"""
              The Clock stops at {current_time} still.
              Again, I have to make choices. Wait, why would I say 'still' and 'again'? \n""")
        print("Again, you have to make choices. Wait, why would I say again? \n")
        input('<What the hell?>\n')
        stage_1()
    elif choice == "b":
        print("You jump into the lake right when he tried to cut you'. \n")
        input('<Press any key to continue>\n')
        end_real()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        choice_secret()   

def end_real():
    print(f"""
          {' ^' *10} SYSTEM WARNING {' ^' *10} \n
          Warning, Syatem error, Subject {name} tracking loss. \n
          ...Internal program inspection processing {' .' *10} \n
          """)
    input('<Press any key to continue>\n')
    print(f"""
          Experimental Subject {name} has ejected from the laboratory. \n
          {' ^' *10} WARNING {' ^' *10} \n
          SYSTEM BREAKDOWN {' .' *20} \n
          """)
    input('<Press any key to continue>\n')
    print("You opened your eyes, it seems you just woke up from a nightmare.\n")
    input('<Press any key to continue>\n')
    print("You are tired and your vision is blurred, but you see two people wearing white robes talking.\n")
    print("You can’t turn your neck, but you feel that this place should be like a laboratory.\n")
    input('<Press any key to continue>\n')
    print("Theer are two people seemed to be arguing, and one of them said: It's all your fault, and I know the system is flawed.\n")
    print("Another person retorted: Stop the noise, quickly confirm the condition of the subject, we need to hibernate it quickly.\n")
    input('<Press any key to continue>\n')
    print("When they look back, you find that they are not humans, but very similar to the monsters in your dreams.\n")
    input('<Press any key to continue>\n')
    print("They seem to have pressed some button. You were taken by the instrument to a domed, warehouse-like place.\n")
    print("Suddenly, you were shocked by the sight before you.\n")
    input('<Press any key to continue>\n')
    print("The warehouse is full of human heads, filled with electrodes.\n")
    print("and many more?\n")
    input('<Press any key to continue>\n')
    print("No way!\n")
    input('<Press any key to continue>\n')
    print("The machine stops, and you are stored in a place similar to a dormant cabin,\n")
    print("Through the reflection of the glass, you can see your true appearance:\n")
    input('<Press any key to continue>\n')
    print("A pale brain, expressionless, even skinless.\n")
    input('<Press any key to continue>\n')
    print("You hear the system say that human experiment body No. 8102, which was stored in the human year, {age}, will undergo dormancy processing.\n")
    input('<Press any key to continue>\n')
    print("You feel so sleepy, you slowly closed your eyes\n")
    input('<Press any key to continue>\n')
    input('<The next day?>\n')
    
    print("""
    You wake up from a nightmare
    You are in a small wooden house that seems familiar,
    The sun came in, it was so dazzling,
    Ah, it turned out to be a dream? You sighed
    When you walk out of the room, everything is so warm. \n""")
    input('<Press any key to continue>\n')
    question_name = "AreyouBackHome?"+f"{name}"
    list1 = Convert(question_name)
    for i in list1:
        print (i)
    print("""
    . 
    ...
    .........
    ............
    ...............
    """)
    time.sleep(3)
    print(f"""
    The clock is still ticking,
    but the pointer stucked for some reason,
    it shows{current_time}. \n
    The End. \n
    """)
    print("Thanks for playing!")

def Convert(string): 
    list1=[] 
    list1[:0]=string 
    return list1 

def kill():
    print("You successfully killed the 'old' you, and you caught up with and killed the monster who was dressed exactly like you. \n")
    input('<Press any key to continue>\n')
    print("You returned to the room, you looked at the time on the screen, but were surprised to find that the current time is still {current_time}, and your psychological defense has collapsed.\n")
    input('<Press any key to continue>\n')
    print("Wait! You try to clear your thought \n")
    input('<Press any key to continue>\n')
    print("Is the stele in the portal a scam? \n")
    input('<Press any key to continue>\n')
    print("Therefore, you decide:、\n")
    print("a) Rescue yourself! \n"
          "b) No, I will be trapped here forever \n")
    choice = input("Please enter a or b to indicate your choice: \n")
    if choice == "a":
        print("You decide to save the original yourslef who just reborn \n")
        input('<Press any key to continue>\n')
        stage_3()
    elif choice =="b":
        fail()
    else:
        print("Your memory is so messed up, you can’t make other decisions")
        input('<Press any key to continue>\n')
        kill()
    
def rescue():
    rescue_rate= random.random()
    if rescue_rate <0.2:
        print("Hesitating in place, the monster takes the opportunity to kill him, of course, you can't escape the end of death. ")
        death_text()
        print(f"""
        The Clock stops at {current_time} still.
        Again, I have to make choices. Wait, why would I say 'still' and 'again'? \n""")
        print("Again, you have to make choices. Wait, why would I say again? \n")
        input('<What the hell?>\n')
        stage_1()
    else:
        print("You successfully guided the past you away from the killer \n")
        choice_7()

def death_text():
    input('<You are dead. But are you?>\n')
    print("You wake up from a nightmare, your thoughts are very confused, it is raining outside, you look at the current time, and decide to pick up the silver sword and go out to see the situation.")
    input('<Press any key to continue>\n')
    print("Was that a dream? You asked yourself in your mind")
    input('<Press any key to continue>\n')
 
def fail():
    print(f"You are lost, {name}.You are trapped in this time and space forever")
    retry = input("Do you wanna start over? Y or N \n")
    if retry == "Y":
        print("Before you start again, you must be on trial. \n")
        num_user = input("Tell me a 3-digit number does satisfy: \n"
                         "Example: 371 = 3*3*3 + 7*7*7 + 1*1*1 \n")
        try:
            num_user = int(num_user)
            for i in range(100,1000):
                a = i%10
                b = i//10%10
                c = i//100
                if num_user == 371:
                    print("Smart copy! I will give you one more chance. ")
                    main()
                elif a*a*a+b*b*b+c*c*c == num_user:
                    print("Genius, you deserve one more chance")
                    main()
                else: 
                    continue
            print("You failed, Thanks for Playing!")
        except ValueError:
            print("Please input a 3-digit number")
            input('<Press any key to continue>\n')
            fail()
            
    elif retry == "N":
        print("Thanks for playing!")
    else:
        print("Please input 'Y' for Yes or 'N' for No \n")
        fail()
    
main()