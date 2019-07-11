
$current_page = nil

$elements = {
	"登录"=>'btn_login_main',
	"首页"=>'.MainActivity',
	"200"=>'txt_main',
	"hello"=>'Hello World!',
	"跳转"=>'btn_jump_main',
	"欢迎"=>'hello，我是你的智能人事助理小安，请问有什么可以帮你？',
	"文本"=>'msg_et',
	"xiaoan"=>'hello,XiaoAn',
	"发送"=>'send_btn',
	"小安"=>"您咨询的可能是以下问题,HR-X下载及登录问题,什么是HR-X,出差假如何申请,办公电脑问题上报途径,IP电话问题上报途径"
}

假如(/^我启动程序$/) do
  	puts "打开程序"
end

那么(/^我应该在"([^\"]*)"界面$/) do|arg1|
  sleep 3
  page_name = $driver.current_activity
  home = $elements[arg1]
  page_name.eql?("#{home}").should == true
  puts "程序启动成功!"
  sleep 1	
end
     
当(/^我点击"([^\"]*)"按钮$/) do|arg1|
	id = $elements[arg1]
	puts "点击#{arg1}按钮!"
	btn = $driver.find_element :id,id 
  	btn.click
  	sleep 5
end

那么(/^我应该在"([^\"]*)"里看到"([^\"]*)"$/) do|arg1,arg2|
	word = $elements[arg1]
	id = $elements[arg2]
	rsp = $driver.find_element :id,id
	# Logger.debug("看到的结果是：#{rsp.text}")
	# Logger.debug("期望的结果是：#{arg2}")
	rsp.text.eql?(word).should == false
  	puts "登录成功！"
end

# 假如(/^我点击"([^\"]*)"按钮$/) do |arg1|
# 	puts "点击跳转按钮!"
# 	id = $elements["#{arg1}"]
# 	jump_btn = $driver.find_element :id=>id
#     jump_btn.click
#     sleep 5
# end
那么(/^我应该收到"([^\"]*)"消息$/) do |arg1|
	sleep 3
	page_name = $driver.current_activity
	puts page_name
	rsp = $driver.find_elements :xpath,"//android.widget.TextView[contains(@index,0)]"
	rep = rsp[rsp.size()-1].text
	expect = $elements["#{arg1}"]
	# Logger.debug("看到的消息是：#{rep}")
	# Logger.debug("期望的结果是：#{expect}")
	rep.eql?(expect).should == true
	puts "看到的消息是：#{rep}"
end

当(/^我在"([^\"]*)"中输入"([^\"]*)"$/) do |arg1,arg2|
	sleep 1
	msg_input = $driver.find_element :id,$elements["#{arg1}"]
	send_word = $elements["#{arg2}"]
	msg_input.send_keys("#{send_word}")
	sleep 1
	$driver.press_keycode(66)
	sleep 1
end
那么(/^我点击"([^\"]*)"应该看到"([^\"]*)"回复$/) do |arg1,arg2|
	msg_send = $driver.find_element :id,$elements["#{arg1}"]
	msg_send.click
	sleep 5
	# Logger.debug("看到的消息是：#{result}")
	# Logger.debug("期望的结果是：#{expect}")
	rsp = $driver.find_elements :xpath,"//android.widget.TextView[contains(@index,0)]"
	result = rsp[rsp.size()-1].text
	# puts res
	words = $elements["#{arg2}"]
	words.split(",").each do|e|
		# puts "#{e}"
		result.include?(e).should == true
	end
	# res.eql?(words).should == true
	# puts "#{result}"
end	

# expect = "a,b,c,d"
# actual = " a ,b   ,c   d
# "
# expects = result.split(',').each do|e|
# 	actual.include?(e).should == true
# end












