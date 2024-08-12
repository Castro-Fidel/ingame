import subprocess
import threading
import time
from typing import Union

import pygame
from pygame.joystick import Joystick


class Gamepad:
    LB_BUTTON = 4
    RB_BUTTON = 5
    LEFT_RIGHT_AXIS = 0
    LEFT_RIGHT_AXIS_SENSITIVITY = 0.7
    UP_DOWN_AXIS = 1
    UP_DOWN_AXIS_SENSITIVITY = 0.7
    APPLY_BUTTON = 0
    BACK_BUTTON = 1

    def __init__(self):
        self.joystick: Union[Joystick, None] = None

        self.terminated: bool = False

        self.last_left_clicked: bool = False
        self.last_right_clicked: bool = False
        self.last_up_clicked: bool = False
        self.last_down_clicked: bool = False

        self.last_dpad_left_clicked: bool = False
        self.last_dpad_right_clicked: bool = False
        self.last_dpad_up_clicked: bool = False
        self.last_dpad_down_clicked: bool = False

        self.lb_clicked: () = lambda: None
        self.rb_clicked: () = lambda: None
        self.l_clicked: () = lambda: None
        self.r_clicked: () = lambda: None
        self.u_clicked: () = lambda: None
        self.d_clicked: () = lambda: None
        self.back_clicked: () = lambda: None
        self.apply_clicked: () = lambda: None

        self.thread: Union[threading.Thread, None] = None

        pygame.init()
        pygame.joystick.init()

    def run(self):
        self.thread = threading.Thread(target=lambda t, _exec: t.cycle(), args=(self, exec))
        self.thread.start()

    def cycle(self):
        joysticks = {}
        hat = [0, 0]

        try:
            while not self.terminated:
                time.sleep(0.05)

                for event in pygame.event.get():
                    # Handle hotplugging
                    if event.type == pygame.JOYDEVICEADDED:
                        # This event will be generated when the program starts for every
                        # joystick, filling up the list without needing to create them manually.
                        self.joystick = pygame.joystick.Joystick(event.device_index)
                        joysticks[self.joystick.get_instance_id()] = self.joystick

                    if event.type == pygame.JOYDEVICEREMOVED:
                        del joysticks[event.instance_id]
                        for joy in joysticks:
                            if joy != None:
                                self.joystick = joysticks[joy]
                                break

                    if event.type == pygame.JOYBUTTONDOWN:
                        self.joystick = joysticks[self.joystick.get_instance_id()]

                        # LB
                        if event.button == self.LB_BUTTON:
                            self.lb_clicked()
                        # RB
                        if event.button == self.RB_BUTTON:
                            self.rb_clicked()
                        # APPLY
                        if event.button == self.APPLY_BUTTON:
                            self.apply_clicked()
                        # BACK
                        if event.button == self.BACK_BUTTON:
                            self.back_clicked()

                    if event.type == pygame.JOYAXISMOTION:
                        self.joystick = joysticks[event.instance_id]
                        left_right_axis = self.joystick.get_axis(self.LEFT_RIGHT_AXIS)
                        up_down_axis = self.joystick.get_axis(self.UP_DOWN_AXIS)
                        # LEFT
                        if (left_right_axis <= -self.LEFT_RIGHT_AXIS_SENSITIVITY) and not self.last_left_clicked:
                            self.last_left_clicked = not self.last_left_clicked
                            self.l_clicked()

                        if not (left_right_axis <= -self.LEFT_RIGHT_AXIS_SENSITIVITY) and self.last_left_clicked:
                            self.last_left_clicked = not self.last_left_clicked

                        # RIGHT
                        if (left_right_axis >= self.LEFT_RIGHT_AXIS_SENSITIVITY) and not self.last_right_clicked:
                            self.last_right_clicked = not self.last_right_clicked
                            self.r_clicked()

                        if (not left_right_axis >= self.LEFT_RIGHT_AXIS_SENSITIVITY) and self.last_right_clicked:
                            self.last_right_clicked = not self.last_right_clicked

                        # UP
                        if (up_down_axis <= -self.UP_DOWN_AXIS_SENSITIVITY) and not self.last_up_clicked:
                            self.last_up_clicked = not self.last_up_clicked
                            self.u_clicked()

                        if not (up_down_axis <= -self.UP_DOWN_AXIS_SENSITIVITY) and self.last_up_clicked:
                            self.last_up_clicked = not self.last_up_clicked

                        # DOWN
                        if (up_down_axis >= self.UP_DOWN_AXIS_SENSITIVITY) and not self.last_down_clicked:
                            self.last_down_clicked = not self.last_down_clicked
                            self.d_clicked()

                        if (not up_down_axis >= self.UP_DOWN_AXIS_SENSITIVITY) and self.last_down_clicked:
                            self.last_down_clicked = not self.last_down_clicked

                    # DPAD support
                    if event.type == pygame.JOYHATMOTION:
                        self.joystick = joysticks[event.instance_id]
                        for i in event.value:
                            hat[i] = event.value[i]

                        if (hat[0] == 0 and hat[1] == 0):
                            self.last_dpad_left_clicked = False
                            self.last_dpad_right_clicked = False
                            self.last_dpad_up_clicked = False
                            self.last_dpad_down_clicked = False
                            continue

                        # LEFT
                        if (hat[0] == -1 and hat[1] == 0 and not self.last_dpad_left_clicked):
                            self.last_dpad_left_clicked = not self.last_dpad_left_clicked
                            self.l_clicked()

                        # RIGHT
                        if (hat[0] == 1 and hat[1] == 0 and not self.last_dpad_right_clicked):
                            self.last_dpad_right_clicked = not self.last_dpad_right_clicked
                            self.r_clicked()

                        # UP
                        if (hat[0] == 0 and hat[1] == 1 and not self.last_dpad_up_clicked):
                            self.last_dpad_up_clicked = not self.last_dpad_up_clicked
                            self.u_clicked()

                        # DOWN
                        if (hat[0] == 0 and hat[1] == -1 and not self.last_dpad_down_clicked):
                            self.last_dpad_down_clicked = not self.last_dpad_down_clicked
                            self.d_clicked()

                        hat = [0, 0]

        except pygame.error as e:
            print(e)
            pass

    def terminate(self):
        self.terminated = True
        pygame.quit()
        pass

    pass
