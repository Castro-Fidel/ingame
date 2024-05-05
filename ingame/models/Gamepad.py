import subprocess
import threading
from typing import Union

import pygame
from pygame.joystick import Joystick


class Gamepad:
    LB_BUTTON = 4
    RB_BUTTON = 5
    LEFT_RIGHT_AXIS = 0
    LEFT_RIGHT_AXIS_SENSITIVITY = 0.7
    APPLY_BUTTON = 0

    def __init__(self):
        self.joystick: Union[Joystick, None] = None
        self.terminated: bool = False
        self.last_rb_clicked: bool = False
        self.last_lb_clicked: bool = False
        self.last_apply_clicked: bool = False
        self.last_left_clicked: bool = False
        self.last_right_clicked: bool = False
        self.lb_clicked: () = lambda: None
        self.rb_clicked: () = lambda: None
        self.l_clicked: () = lambda: None
        self.r_clicked: () = lambda: None
        self.apply_clicked: () = lambda: None
        self.thread: Union[threading.Thread, None] = None

        pygame.init()
        pygame.joystick.init()

    def run(self):
        joystick_count = pygame.joystick.get_count()
        if joystick_count == 0:
            print("No joysticks found.")
        else:
            self.joystick = pygame.joystick.Joystick(0)
            self.joystick.init()

            self.thread = threading.Thread(target=lambda t, _exec: t.cycle(), args=(self, exec))
            self.thread.start()

    def cycle(self):
        try:

            # TODO: use this instead:
            # events = pygame.event.get()
            # for event in events:
            #     if event.type == pygame.JOYBUTTONDOWN:

            while not self.terminated:
                # pygame.event.pump()
                pygame.event.wait()

                lb_button = self.joystick.get_button(self.LB_BUTTON)
                rb_button = self.joystick.get_button(self.RB_BUTTON)
                apply_button = self.joystick.get_button(self.APPLY_BUTTON)
                left_right_axis = self.joystick.get_axis(self.LEFT_RIGHT_AXIS)

                # LB

                if lb_button and not self.last_lb_clicked:
                    self.last_lb_clicked = not self.last_lb_clicked
                    self.lb_clicked()

                if not lb_button and self.last_lb_clicked:
                    self.last_lb_clicked = not self.last_lb_clicked

                # RB

                if rb_button and not self.last_rb_clicked:
                    self.last_rb_clicked = not self.last_rb_clicked
                    self.rb_clicked()

                if not rb_button and self.last_rb_clicked:
                    self.last_rb_clicked = not self.last_rb_clicked

                # APPLY

                if apply_button and not self.last_apply_clicked:
                    self.last_apply_clicked = not self.last_apply_clicked
                    self.apply_clicked()

                if not apply_button and self.last_apply_clicked:
                    self.last_apply_clicked = not self.last_apply_clicked

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

                # print(f"Button {self.LB_BUTTON}: {lb_button}")
                # print(f"Button {self.RB_BUTTON}: {rb_button}")

                # for i in range(self.joystick.get_numaxes()):
                #     axis = self.joystick.get_axis(i)
                #     print(f"Axis {i}: {axis}")

                # for i in range(self.joystick.get_numbuttons()):
                #     button = self.joystick.get_button(i)
                #     print(f"Button {i}: {button}")
        except pygame.error:
            pass

    def terminate(self):
        self.terminated = True
        pygame.quit()
        pass

    pass
