# This program creates a quit
# button. When we press the button,
# the application terminates.

include Java

import javax.swing.JFrame
import javax.swing.JButton
import javax.swing.JPanel
import java.lang.System

class QuitFrame < JFrame

  def initialize
    super "Quit Button"
    self.initUI
  end

  def initUI
    panel = JPanel.new
    self.getContentPane.add(panel)

    panel.setLayout(nil)

    qbutton = JButton.new("Quit")
    qbutton.setBounds(50, 60, 80, 30)
    qbutton.add_action_listener do |e|
      System.exit(0)
    end

    panel.add(qbutton)

    self.setDefaultCloseOperation(JFrame::EXIT_ON_CLOSE)
    self.setSize(300, 200)
    self.setLocationRelativeTo(nil)
    self.setVisible(true)
  end

end

QuitFrame.new
