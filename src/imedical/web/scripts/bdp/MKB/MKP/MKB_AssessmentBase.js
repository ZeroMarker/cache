/*
Creator:石萧伟
CreatDate:2017-05-09
Description:评估表注册
*/
/**************************************************右侧评估系统开始*********************************/
//点击评分结果添加按钮
function addNewLevel() {
	var newlevel = "<div class='scoreclassN' style='border-top:1px dashed #C0C0C0;'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input class='minscore' type='text' style='width:60px;'></td><td>-</td><td><input class='maxscore'  type='text' style='width:60px;'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' onclick='delLevel(this)' style='border: 0px;cursor:pointer'></td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input class='levelscore'  type='text' style='width:155px;'></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text' style='width:157px;height:50px'  ></textarea></td></tr></table></div>"
	$('#scorelevelN').append(newlevel);
	$('.minscore').validatebox();
	$('.maxscore').validatebox();
	$('.levelscore').validatebox({});
	justscore();

}

//分值范围判断
/*function justscore()
{
	$('.minscore').keyup(function(){	
	})
	$('.maxscore').keyup(function(){
		var score=(($('.scoreP').text()).split("（")[1]).split("分")[0]
		alert(score)
		var max=$(this).val()
		
	})
}*/
//判断是否符合格式要求
function justscore() {
	$('.minscore').keyup(function () {
		var score = (($('.scoreP').text()).split("（")[1]).split("分")[0];
		var minrank = $(this).val();
		if (isNaN(minrank) && minrank.length > 1) {
			/*$.messager.show
			({ 
				title: '提示消息', 
				msg: '请输入有效的值！', 
				showType: 'show', 
				timeout: 1000, 
				style: { 
				right: '', 
				bottom: ''
				} 
			});*/
			$.messager.popover({ msg: '请输入有效值！', type: 'alert' });
			$(this).val("");
		}
		if ((minrank - 0) > (score - 0)) {
			/*$.messager.show
			({ 
				title: '提示消息', 
				msg: '分数值不能超过总分！', 
				showType: 'show', 
				timeout: 1000, 
				style: { 
				right: '', 
				bottom: ''
				} 
		   });*/
			$.messager.popover({ msg: '分值不能超过总分！', type: 'alert' });
			$(this).val("");
		}
	})
	$('.maxscore').keyup(function () {
		var score = (($('.scoreP').text()).split("（")[1]).split("分")[0];
		var max = $(this).val();
		if (isNaN(max) && max.length > 1) {
			/*$.messager.show
			({ 
				title: '提示消息', 
				msg: '请输入有效的值！', 
				showType: 'show', 
				timeout: 1000, 
				style: { 
				right: '', 
				bottom: ''
				} 
			});*/
			$.messager.popover({ msg: '请输入有效值！', type: 'alert' });
			$(this).val("");
		}
		if ((max - 0) > (score - 0)) {
			/*$.messager.show
			({ 
				title: '提示消息', 
				msg: '分数值不能超过总分！', 
				showType: 'show', 
				timeout: 1000, 
				style: { 
				right: '', 
				bottom: ''
				} 
		   });*/
			$.messager.popover({ msg: '请输入有效值！', type: 'alert' });
			$(this).val("");
		}
	})

}
/**************************************************右侧评估系统jieshu*********************************/
/*************************************************选项上移下移开始*********************************/
// 上移 
function moveUp(obj) {
	var current = $(obj).parent().parent(); //获取当前<tr>
	var prev = current.prev();  //获取当前<tr>前一个元素
	if (current.index() > 1) {
		current.insertBefore(prev); //插入到当前<tr>前一个元素前
		current.find('input,textarea').each(function () {
			$(this).focus();//将光标默认到该行
		});
	}
	else {
		/*$.messager.show
	  ({ 
		  title: '提示消息', 
		  msg: '不能越过列名！', 
		  showType: 'show', 
		  timeout: 1000, 
		  style: { 
		  right: '', 
		  bottom: ''
		  } 
	 }); */
		$.messager.popover({ msg: '不能越过列名！', type: 'alert' });
	}
}
// 下移 
function moveDown(obj) {
	var current = $(obj).parent().parent(); //获取当前<tr>
	var next = current.next(); //获取当前<tr>后面一个元素
	if (next.length > 0) {
		current.insertAfter(next);  //插入到当前<tr>后面一个元素后面
		current.find('input,textarea').each(function () {
			$(this).focus();//将光标默认到该行
		});
	}
	else {
		/*$.messager.show
	  ({ 
		  title: '提示消息', 
		  msg: '已经是最后一个了！', 
		  showType: 'show', 
		  timeout: 1000, 
		  style: { 
		  right: '', 
		  bottom: ''
		  } 
	 });*/
		$.messager.popover({ msg: '这已经是最后一个了！', type: 'alert' });
	}
}
//选项按钮隐藏和显示
function hoverTr() {
	$(".hovertr").hover(function () {
		var newtd = "<img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='padding-left:10px;border: 0px;cursor:pointer' onclick='moveDown(this)'><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' onclick='delCombo(this)' style='padding-left:10px;border: 0px;cursor:pointer'>"
		//$(this).children('.hidetd').remove();
		$(this).children(".childhover").html("")
		$(this).children(".childhover").append(newtd);
	}, function () {
		$(this).children(".childhover").html("&nbsp&nbsp");
	})
}
/*************************************************选项上移下移结束*********************************/
/*************************************************扩展列上移下移删除复制开始*********************************/
// 上移 
function moveUpAll(obj) {
	var current = $(obj).parent().parent().parent(); //获取当前所在div
	var prev = current.prev();  //获取当前div前一个元素
	if (current.index() > 0) {
		current.insertBefore(prev); //插入到当前div前一个元素前
		//将列的标签重新命名
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
	}
	else {
		/*$.messager.show
	  ({ 
		  title: '提示消息', 
		  msg: '不能越过标题项！', 
		  showType: 'show', 
		  timeout: 1000, 
		  style: { 
		  right: '', 
		  bottom: ''
		  } 
	 }); */
		$.messager.popover({ msg: '不能越过标题项！', type: 'alert' });
	}
}
// 下移 
function moveDownAll(obj) {
	var current = $(obj).parent().parent().parent(); //获取当前所在div
	var next = current.next(); //获取当前div后面一个元素
	if (next.length > 0) {
		current.insertAfter(next);  //插入到当前div后面一个元素后面
		//将列的标签重新命名
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
	}
	else {
		/*$.messager.show
	  ({ 
		  title: '提示消息', 
		  msg: '已经是最后一个了！', 
		  showType: 'show', 
		  timeout: 1000, 
		  style: { 
		  right: '', 
		  bottom: ''
		  } 
	 });*/
		$.messager.popover({ msg: '已经是最后一个了！', type: 'alert' });
	}
}
/*************************************************扩展列上移下移删除复制结束*********************************/
//点击删除通用按钮方法
function delCombo(obj) {
	var current = $(obj).parent().parent(); //获取当前<tr>
	//获取上一个
	var prev = current.prev();  //获取当前div前一个元素
	//获取下一个
	var next = current.next(); //获取当前div后面一个元素
	if (prev.length == 1 && next.length < 0) {
		/*$.messager.show
		  ({ 
			  title: '提示消息', 
			  msg: '至少存在一个选项，不能再删了！', 
			  showType: 'show', 
			  timeout: 1000, 
			  style: { 
			  right: '', 
			  bottom: ''
			  } 
		});*/
		$.messager.popover({ msg: '至少存在一个选项，不能再删了！', type: 'alert' });
	}
	else {
		current.remove();
		//将列的标签重新命名
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
	}
	var allscore = 0;
	$('#registerMain').find('.movediv').each(function () {
		//遍历每一项，判断类型
		var scoreid = $(this).attr("id");
		var whole = scoreid.split("whole")[1];//获取本块的顺序数字 
		var flag = whole.split("A")[2];
		var idNum = whole.split("A")[1];
		if (flag == "C" || flag == "R") {
			var max = 0;
			$(this).find('.socerclass').each(function () {
				var score = $(this).val();
				if (parseFloat(score) > parseFloat(max)) {
					max = score;
				}

			})
			allscore = addNum(allscore,max)//(allscore - 0) + (max - 0);
		}
		else if (flag == "H") {
			$(this).find('.socerclass').each(function () {
				var score = $(this).val();
				allscore = addNum(allscore,score)//(allscore - 0) + (score - 0);
			})
		}
	})
	//allscore = allscore * 10 / 10
	$('.scoreP').text("（" + allscore + "分）");
	$(".minscore").val("");//删除的
	$(".maxscore").val("");
}
var init = function () {
	//评分结果删除按钮
	var DELETE_SCORE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssessmentScoringRules&pClassMethod=DeleteData";
	delLevel = function (obj) {
		var record = mygrid.getSelected();
		var current = $(obj).parent().parent().parent().parent().parent();
		var rowid = "";
		$(obj).parent().parent().parent().parent().parent().find('.hiddenRowid').each(function () {
			rowid = $(this).text();
		})
		if (record && rowid != "") {
			$.messager.confirm('提示', '确定要删除所选数据吗?', function (r) {
				if (r) {
					current.remove();
					$.ajax({
						url: DELETE_SCORE_URL,
						data: { "id": rowid },
						type: "POST",
						success: function (data) {
							var data = eval('(' + data + ')');
							if (data.success == 'true') {
								/*$.messager.show({
									title: '提示消息',
									msg: '删除成功',
									showType: 'show',
									timeout: 1000,
									style: {
										right: '',
										bottom: ''
									}
								});*/
								$.messager.popover({ msg: '删除成功！', type: 'success', timeout: 1000 });
							}
							else {
								var errorMsg = "删除失败！";
								if (data.info) {
									errorMsg = errorMsg + '<br/>错误信息:' + data.info;
								}
								$.messager.alert('操作提示', errorMsg, "error");

							}
						}
					})
				}
			})
		}
		else {
			var current = $(obj).parent().parent().parent().parent().parent();
			current.remove();
		}
	}
	justscore();
	var rownumber = 1;//记录条数
	var row = 1;
	//整体效果按钮通用方法
	var DELETE_CONM_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssessmentBaseField&pClassMethod=DeleteData";
	function moveAll() {
		$(".movediv").hover(function () {
			//显示添加按钮
			$(this).find('.addhover').each(function () {
				$(this).show();
			})
			var html_cz = "<div style='float:left;padding-left:30px' class='kzqy_czbut'><img class='sy' src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='padding-right:10px;border: 0px;cursor:pointer' onclick='moveUpAll(this)'></br><img class='xy' src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='padding-right:10px;padding-top:10px;border: 0px;cursor:pointer' onclick='moveDownAll(this)'></br><img class='fz' src='../scripts/bdp/Framework/icons/mkb/copyorder.png' style='padding-right:10px;padding-top:10px;border:0px;cursor:pointer' ></br><img class='sc' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' style='padding-right:10px;padding-top:10px;border:0px;cursor:pointer'></div>";
			$(this).children(".allbarclass").children(".kzqy_czbut").remove();
			//$(this).children(".classChild").after(html_cz);
			$(this).children(".allbarclass").append(html_cz);
			var whole = $(this).attr("id").split("whole")[1];//获取本块的顺序数字 
			var flag = whole.split("A")[2];
			var idNum = whole.split("A")[1];
			//点击删除整体按钮
			$('.sc').click(function (e) {
				var record = mygrid.getSelected();
				var current = $(this).parent().parent().parent();
				var rowid = "";
				$(this).parent().parent().parent().find('.hiddenRowid').each(function () {
					rowid = $(this).text();
				})
				if (record && rowid != "") {
					$.messager.confirm('提示', '确定要删除所选数据吗?', function (r) {
						if (r) {
							current.remove();
							rownumber--;
							var num = 1;
							$('#overshow').find('p').each(function () {
								$(this).text("列" + num);
								num++;
							})
							replayscore();
							$(".minscore").val("");//删除的
							$(".maxscore").val("");
							$.ajax({
								url: DELETE_CONM_URL,
								data: { "id": rowid },
								type: "POST",
								success: function (data) {
									var data = eval('(' + data + ')');
									if (data.success == 'true') {
										/*$.messager.show({
											title: '提示消息',
											msg: '删除列信息成功',
											showType: 'show',
											timeout: 1000,
											style: {
												right: '',
												bottom: ''
											}
										});*/
										$.messager.popover({ msg: '删除列信息成功！', type: 'success', timeout: 1000 });
									}
									else {
										var errorMsg = "删除失败！"
										if (data.info) {
											errorMsg = errorMsg + '<br/>错误信息:' + data.info;
										}
										$.messager.alert('操作提示', errorMsg, "error");

									}
								}
							})
						}
					})
				}
				else {
					var current = $(this).parent().parent().parent();
					current.remove();
					rownumber--;
					var num = 1;
					$('#registerMain').find('p').each(function () {
						$(this).text("Q" + num);
						num++;
					})
					replayscore();
				}

			})
			//点击复制按钮
			$('.fz').click(function (e) {
				var insideNum = 2;
				var otherrow = row;//从新定义一个变量避免在添加选项时冲突
				var insidecount = 1;//记录条数
				//获取标题
				var num = 1
				$('#table' + idNum).find('input,textarea').each(function () {
					//var text=$(this).text();
					var text = $(this).val();
					if (num == 1) {
						if (flag == "C") {
							var newDiv = "<div class='movediv' id='wholeA" + row + "AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  align='center' style='float:left;padding:10px 10px 10px 1px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + text + "'></td><td>（下拉框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
							$('#registerMain').append(newDiv);
							//添加新扩展列跳转
							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AC").offset().top},500);
							//location.hash="#wholeA"+row+"AC"
							$('#positionId' + row).focus();
							//插入单条按钮
							var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td style='display:none' class='addhover'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
							$('#divID' + row).append(newbutton);
							//插入多条按钮
							var muchbutton = "<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
							$('#toolstr' + row).append(muchbutton);
							addComSelect(row, otherrow, insideNum, insidecount)
							moveAll();

						}
						if (flag == "R") {
							var newDiv = "<div class='movediv' id='wholeA" + row + "AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + text + "'></td><td>（单选框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
							$('#registerMain').append(newDiv);
							//添加新扩展列跳转
							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AR").offset().top},500);
							//window.location.hash="#wholeA"+row+"AR"
							$('#positionId' + row).focus();
							//插入单条按钮
							var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
							$('#divID' + row).append(newbutton);
							//插入多条按钮
							var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
							$('#toolstr' + row).append(muchbutton);
							addRadSelect(row, otherrow, insideNum, insidecount)
							moveAll();

						}
						if (flag == "H") {
							var newDiv = "<div class='movediv'  id='wholeA" + row + "AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + text + "'></td><td>（复选框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
							$('#registerMain').append(newDiv);
							//添加新扩展列跳转
							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AH").offset().top},500);
							//window.location.hash="#wholeA"+row+"AH"
							$('#positionId' + row).focus();
							//插入单条按钮
							var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
							$('#divID' + row).append(newbutton);
							//插入多条按钮
							var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
							$('#toolstr' + row).append(muchbutton);
							addCheckSelected(row, otherrow, insideNum, insidecount)
							moveAll();
						}
						if (flag == "I") {
							var newDiv = "<div class='movediv' id='wholeA" + row + "AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text' value='" + text + "'></td><td>（单行文本）</td></tr></table></div></div>";
							$('#registerMain').append(newDiv);
							//添加新扩展列跳转
							//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AI").offset().top},500);
							//window.location.hash="#wholeA"+row+"AI"
							$('#positionId' + row).focus();
							$('#positionId' + row).focus();
							moveAll();
							$('.hisbox').validatebox({
							});
						}
						if (flag == "T") {
							var newDiv = "<div class='movediv' id='wholeA" + row + "AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text' value='" + text + "'></td><td>（多行文本）</td></tr></table></div></div>";
							$('#registerMain').append(newDiv);
							//添加新扩展列跳转
							$('#overshow').animate({ scrollTop: $("#wholeA" + row + "AT").offset().top }, 500);
							//window.location.hash="#wholeA"+row+"AT"
							moveAll();
							$('.hisbox').validatebox({
							});
						}

					}
					num++;

				})
				//获取选项
				var num2 = 1;
				$('#table' + idNum).find('input,textarea').each(function () {
					if (num2 == 1) {
						num2++;
					}
					else if (num2 != 1) {
						var values = $(this).val();
						if (flag == "C") {

							if (num2 % 2 == 0) {

								var addRow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'>选项" + (insideNum - 1) + "</td><td><textarea class='hisbox' style='width:200px;'  id='comboNum" + otherrow + "A" + insideNum + "' type='text'>"+values+"</textarea></td></tr>";
								$('#table' + otherrow).append(addRow);
								insideNum--;
							}
							else {
								var addtd = "<td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + values + "'></td><td class='childhover'></td>";
								$('#option' + otherrow + 'A' + insideNum).append(addtd);
							}
							hoverTr();
							//输入框变为hisui样式
							$('.hisbox').validatebox();
							$('.socerclass').validatebox();
							addAllscoreN();
							insideNum++;
							insidecount++;
							num2++;
						}
						var name = $(this).attr("class");
						var flagp = !name.match("all")//去掉单选框
						if (flag == "R" && flagp) {
							if (num2 % 2 == 0) {

								var addRow = "<tr class='hovertr' id='option" + otherrow + "a" + insideNum + "'><td  align='right'><input name='radio" + otherrow + "' type='radio' class='allRadio' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px;' id='comboNum" + otherrow + "A" + insideNum + "' type='text' >"+values+"</textarea></td></tr>";
								$('#table' + otherrow).append(addRow);
								$("#option" + otherrow + "a" + insideNum).attr("id", 'option' + otherrow + "A" + insideNum)
								insideNum--;

							}
							else {
								var addtd = "<td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + values + "'></td><td class='childhover'></td>";
								$('#option' + otherrow + 'A' + insideNum).append(addtd);
							}
							hoverTr();
							//输入框变为hisui样式
							$('.hisbox').validatebox();
							$('.socerclass').validatebox();
							addAllscoreN();
							//将单选框渲染成hisui样式
							$HUI.radio('.allRadio', {
							});
							insideNum++;
							insidecount++;
							num2++;
						}
						if (flag == "H" && flagp) {
							if (num2 % 2 == 0) {
								var addRow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'><input name='checkbox" + otherrow + "' class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px;' id='comboNum" + otherrow + "A" + insideNum + "'   type='text'>"+values+"</textarea></td></tr>";
								$('#table' + otherrow).append(addRow);
								$("#option" + otherrow + "a" + insideNum).attr("id", 'option' + otherrow + "A" + insideNum)
								insideNum--;
							}
							else {
								var addtd = "<td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + values + "'></td><td class='childhover'></td>";
								$('#option' + otherrow + 'A' + insideNum).append(addtd);
							}

							hoverTr();
							//输入框变为hisui样式
							$('.hisbox').validatebox();
							$('.socerclass').validatebox();
							addAllscoreN();
							//将duo选框渲染成hisui样式
							// $HUI.checkbox('.allCheck',{
							// });
							insideNum++;
							insidecount++;
							num2++;
						}
					}
				})
				row++;
				replayscore();
				$(".minscore").val("");//删除的
				$(".maxscore").val("");
				var numF = 1;
				$('#registerMain').find('p').each(function () {
					$(this).text("Q" + numF);
					numF++;
				})
			})
		}, function () {
			$(this).children(".allbarclass").children(".kzqy_czbut").remove();
			//$('.tableshow').hide();
			//隐藏添加按钮
			$(this).find('.addhover').each(function () {
				$(this).hide();
			})
		});
	}
	/*************************************************新增下拉框按钮点击事件开始*********************************/
	$('#addCombobox').click(function (e) {
		var insideNum = 3;
		var otherrow = row;//从新定义一个变量避免在添加选项时冲突
		var insidecount = 3;//记录条数
		var newDiv = "<div class='movediv' id='wholeA" + row + "AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  align='center' style='float:left;padding:10px 10px 10px 1px;border-left:#40a2de solid 0px;'><table cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text'></td><td>（下拉框）</td><td style='padding-left:50px'>评分</td></tr><tr class='hovertr' id='option" + row + "A2'><td align='right'>选项1</td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + row + "A1' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr><tr class='hovertr' id='option" + row + "A3'><td align='right'>选项2</td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + row + "A2' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AC").offset().top},500);
		//window.location.hash="#wholeA"+row+"AC"
		//document.getElementById("wholeA"+row+"AC").scrollIntoView()
		$('#positionId' + row).focus();
		//输入框变为hisui样式
		$('.hisbox').validatebox({});
		$('.socerclass').validatebox({});
		addAllscoreN();
		//添加单条按钮
		var newbutton = "<table  align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td style='display:none' class='addhover'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></td></tr></table>";
		$('#divID' + row).append(newbutton);
		//插入多条按钮
		var muchbutton = "<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
		$('#toolstr' + row).append(muchbutton);
		addComSelect(row, otherrow, insideNum, insidecount);
		moveAll();
		row++;
		rownumber++;

		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
	})
	/*************************************************新增下拉框按钮点击事件结束*********************************/
	/*************************************************新增单选按钮点击事件开始*********************************/
	$('#addRadio').click(function (e) {
		var insideNum = 3;
		var otherrow = row;//从新定义一个变量避免在添加选项时冲突
		var insidecount = 3;//记录条数
		//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#FAF4FF'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='单选框' type='text'></td></tr></table><table style='padding-left:80px;' id='table"+row+"'><tr id='option"+row+"A2'><td  class='tdlabel'><input name='radio"+row+"' type='radio' value=''></td><td><input id='comboNum"+row+"A1' value='选项1' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr><tr><td class='tdlabel'><input name='radio"+row+"' type='radio' value=''></td><td><input id='comboNum"+row+"A2' value='选项2' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr></table></div></div>"
		var newDiv = "<div class='movediv' id='wholeA" + row + "AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px;'><table cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text'></td><td>（单选框）</td><td style='padding-left:50px'>评分</td></tr><tr class='hovertr' id='option" + row + "A2'><td  align='right'><input name='radio" + row + "' class='allRadio' type='radio' value=''></td><td><textarea class='hisbox'  style='width:200px;height:28px' id='comboNum" + row + "A1' placeholder='选项1' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr><tr class='hovertr'><td align='right'><input name='radio" + row + "' class='allRadio' type='radio' value=''></td><td><textarea class='hisbox'  style='width:200px;height:28px' id='comboNum" + row + "A2' placeholder='选项2' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AR").offset().top},500);
		//window.location.hash="#wholeA"+row+"AR";
		//document.getElementById("wholeA"+row+"AR").scrollIntoView()
		$('#positionId' + row).focus();
		hoverTr();
		//输入框变为hisui样式
		$('.hisbox').validatebox();
		$('.socerclass').validatebox();
		addAllscoreN();
		//将单选框渲染成hisui样式
		$HUI.radio('.allRadio', {
		});
		//添加单条按钮
		var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></tr></table>";
		$('#divID' + row).append(newbutton);
		//插入多条按钮
		var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
		$('#toolstr' + row).append(muchbutton);
		moveAll();
		addRadSelect(row, otherrow, insideNum, insidecount);
		row++;
		rownumber++;
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num)
			num++;
		})
	})
	/*************************************************新增单选按钮点击事件结束*********************************/
	/*************************************************新增多选按钮点击事件开始*********************************/
	$('#addCheckbox').click(function (e) {
		var insideNum = 3;
		var otherrow = row;//从新定义一个变量避免在添加选项时冲突
		var insidecount = 3;//记录条数
		//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#FAF4FF'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='复选框' type='text'></td></tr></table><table style='padding-left:80px;' id='table"+row+"'><tr id='option"+row+"A2'><td  class='tdlabel'><input name='checkbox"+row+"' type='checkbox' value=''></td><td><input id='comboNum"+row+"A1' value='选项1' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr><tr><td class='tdlabel'><input name='checkbox"+row+"' type='checkbox' value=''></td><td><input id='comboNum"+row+"A2' value='选项2' type='text'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftup.png' style='border: 0px;cursor:pointer' onclick='moveUp(this)'></td><td class='tdlabel'><img  src='../scripts/bdp/Framework/icons/mkb/shiftdown.png' style='border: 0px;cursor:pointer' onclick='moveDown(this)'></td></tr></table></div></div>"
		var newDiv = "<div class='movediv'  id='wholeA" + row + "AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text'></td><td align='left'>（复选框）</td><td style='padding-left:50px'>评分</td></tr><tr class='hovertr' id='option" + row + "A2'><td  align='right'><input name='checkbox" + row + "' class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + row + "A1' placeholder='选项1' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr><tr class='hovertr'><td align='right'><input name='checkbox" + row + "'  class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + row + "A2' placeholder='选项2' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AH").offset().top},500);
		//window.location.hash="#wholeA"+row+"AH";
		//document.getElementById("wholeA"+row+"AH").scrollIntoView()
		$('#positionId' + row).focus();
		hoverTr();
		//输入框变为hisui样式
		$('.hisbox').validatebox();
		$('.socerclass').validatebox();
		addAllscoreN();
		//将duo选框渲染成hisui样式
		// $HUI.checkbox('.allCheck',{
		// });
		//添加单条按钮
		var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' style='border:0px;cursor:pointer'></td></tr></table>";
		$('#divID' + row).append(newbutton);
		//插入多条按钮
		var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "'  style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
		$('#toolstr' + row).append(muchbutton);
		addCheckSelected(row, otherrow, insideNum, insidecount);
		moveAll();

		row++;
		rownumber++;
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;;
		})
	})
	/*************************************************新增多选按钮点击事件结束*********************************/
	/*************************************************新增单行文本点击事件开始*********************************/
	$('#addText').click(function (e) {
		var otherrow = row;//从新定义一个变量避免在添加选项时冲突
		//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#FAF4FF'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='单行文本' type='text'></td></tr></table></div></div>"
		var newDiv = "<div class='movediv' id='wholeA" + row + "AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p class='allbarclass' style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text'></td><td>（单行文本）</td></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AI").offset().top},500);
		//window.location.hash="#wholeA"+row+"AI";
		//document.getElementById("wholeA"+row+"AI").scrollIntoView()
		$('#positionId' + row).focus();
		moveAll();
		row++;
		rownumber++;
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
		$('.hisbox').validatebox({
		});
	})
	/*************************************************新增文本点击事件结束*********************************/
	/*************************************************新增多行文本点击事件开始*********************************/
	$('#addTexts').click(function (e) {
		var otherrow = row;//从新定义一个变量避免在添加选项时冲突
		//var newDiv="<div class='movediv' style='width:800px;padding-left:160px;padding-right:160px'><div class='classChild' id='divID"+row+"'  style='padding-top:20px;padding-bottom:20px;margin-top:10px;background-color:#FAF4FF'><table id='tableN"+row+"'><tr id='option"+row+"A1'><td  class='tdlabel'>新增属性"+row+"</td><td><input id='comboID"+row+"' value='多行文本' type='text'></td></tr></table></div></div>"
		var newDiv = "<div class='movediv' id='wholeA" + row + "AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text'></td><td>（多行文本）</td></tr></table></div></div>";
		$('#registerMain').append(newDiv);
		//添加新扩展列跳转
		//$('#overshow').animate({scrollTop:$("#wholeA"+row+"AT").offset().top},500);
		//window.location.hash="#wholeA"+row+"AT";
		//document.getElementById("wholeA"+row+"AT").scrollIntoView()
		$('#positionId' + row).focus();
		moveAll();
		row++;
		rownumber++;
		var num = 1;
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
		$('.hisbox').validatebox({
		});
	})
	/*************************************************新增多行文本点击事件结束*********************************/

	//判断窗口宽度
	/*var windowWidthM = Math.max(document.documentElement.clientWidth,document.body.clientWidth)
	if (windowWidthM>1600)
	{
	   $('#eastlay').panel('resize',{
	   width: 400
	   });
	}
   else 
   {
	   $('#eastlay').panel('resize',{
	   width: 200
	   });
   }*/

//自定义加法运算
function addNum (num1, num2) {
 var sq1,sq2,m;
 try {
  sq1 = num1.toString().split(".")[1].length;
 }
 catch (e) {
  sq1 = 0;
 }
 try {
  sq2 = num2.toString().split(".")[1].length;
 }
 catch (e) {
  sq2 = 0;
 }
 m = Math.pow(10,Math.max(sq1, sq2));
 return (num1 * m + num2 * m) / m;
}
	//每一个得分绑定keyup来获取总分
	function addAllscoreN() {

		$('.socerclass').keyup(function () {
			var thisscore = $(this).val()
			if (isNaN(thisscore) && thisscore.length > 1) {
				/*$.messager.show
				({ 
					title: '提示消息', 
					msg: '请输入有效的值！', 
					showType: 'show', 
					timeout: 1000, 
					style: { 
					right: '', 
					bottom: ''
					} 
				});*/
				$.messager.popover({ msg: '请输入有效值！', type: 'alert' });
				$(this).val("");
			}
			//alert($(this).val())
			var allscore = 0;
			$('#registerMain').find('.movediv').each(function () {
				//遍历每一项，判断类型
				var scoreid = $(this).attr("id");
				var whole = scoreid.split("whole")[1];//获取本块的顺序数字 
				var flag = whole.split("A")[2];
				var idNum = whole.split("A")[1];
				if (flag == "C" || flag == "R") {
					var max = 0;
					$(this).find('.socerclass').each(function () {
						var score = $(this).val();
						if (parseFloat(score) > parseFloat(max)) {
							max = score;
						}
					})
					allscore = addNum(allscore,max)//(allscore - 0) + (max - 0);

				}
				else if (flag == "H") {
					$(this).find('.socerclass').each(function () {
						var score = $(this).val();
						allscore = addNum(allscore,score)//(allscore - 0) + (score - 0);
					})
				}
			})
			//allscore = allscore * 10 / 10;
			$('.scoreP').text("（" + allscore + "分）");
			//清空等级范围	
			$(".minscore").val("");//添加的
			$(".maxscore").val("");
		})

	}
	//删除一项，复制重新计算总分
	function replayscore() {
		//alert($(this).val())
		var allscore = 0;
		$('#registerMain').find('.movediv').each(function () {
			//遍历每一项，判断类型
			var scoreid = $(this).attr("id");
			var whole = scoreid.split("whole")[1];//获取本块的顺序数字 
			var flag = whole.split("A")[2];
			var idNum = whole.split("A")[1];
			if (flag == "C" || flag == "R") {
				var max = 0;
				$(this).find('.socerclass').each(function () {
					var score = $(this).val();
					if (parseFloat(score) > parseFloat(max)) {
						max = score;
					}

				})
				allscore = addNum(allscore,max)//(allscore - 0) + (max - 0);
			}
			else if (flag == "H") {
				$(this).find('.socerclass').each(function () {
					var score = $(this).val();
					allscore = addNum(allscore,score)//(allscore - 0) + (score - 0);
				})
			}
		})
		//allscore = allscore * 10 / 10;
		$('.scoreP').text("（" + allscore + "分）");
		//$(".minscore").val("");//删除的
		//$(".maxscore").val("");

	}
	/*************************************************保存方法开始****************************************************************/
	var SAVE_BASE_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBAssessmentBase&pClassMethod=SaveEntity&pEntityName=web.Entity.MKB.MKBAssessmentBase";
	//点击保存按钮
	$("#btnSave").click(function (e) {
		saveLeftForm(1);
	})
	function saveLeftForm(flag) {
		var record = mygrid.getSelected();
		if (record) {
			var id = record.MKBABRowId;
		}
		else {
			var id = "";
		}
		var desc = $('#MKBABDesc').val();
		if (desc == "") {
			$.messager.alert('错误提示', '标题不能为空!', "error");
			return;
		}
		if (desc.length>100)
		{
			$.messager.alert('错误提示','标题长度不能超过100!',"error");
			return;
		}
		if ($('#registerMain').html().indexOf("<") < 0) {
			$('#form-save').form('submit', {
				url: SAVE_BASE_URL,
				onSubmit: function (param) {
					param.MKBABRowId = id;
				},
				success: function (data) {
					$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
					$('#assbasegrid').datagrid('reload');  // 重新载入当前页面数据
										var data = eval('(' + data + ')');
					setTimeout(function () {
						$('#assbasegrid').datagrid('selectRecord', data.id)
						viewAllData();
					}, 100);
				}
			});
			return
		}
		//判断是否有空的分值
		var scoreflag = "";
		$('#registerMain').find('.socerclass').each(function () {
			var scoreVal = $(this).val();
			if (scoreVal == "") {
				scoreflag = "N";
				return false;
			}
		});
		// if(scoreflag=="N")
		// {
		// 	$.messager.alert('错误提示','分值项不能为空！',"error");
		// 	return;
		// }
		//判断是同一个题是否有相同的分值
		/*var sameFlag=""
		$('#registerMain').find('.movediv').each(function(){
			var scoreArray=[];
			var scoreIndex=0;
			$(this).find('.socerclass').each(function(){
				scoreArray[scoreIndex]=$(this).val();
				scoreIndex++;	
			})
			var nary=scoreArray.sort(); 
			for(i=0;i<nary.length;i++)
			{
				if (nary[i]==nary[i+1])
				{ 
					sameFlag="N";
					return false;
				} 
			}
		});
		if(sameFlag=="N")
		{
			$.messager.alert('错误提示','同一题分值不能重复！',"error");
			return;		
		}*/
		//判断评分范围是否有空值
		var rangeFlag = "";
		$('#scorelevelN').find('.minscore,.maxscore').each(function () {
			var rangeText = $(this).val();
			if (rangeText == "") {
				rangeFlag = "N";
				return false;
			}
		});
		// if(rangeFlag=="N")
		// {
		// 	$.messager.alert('错误提示','评分范围不能有空值！',"error");
		// 	return;		
		// }
		//判断评分等级是否为空
		var rankFlag = "";
		$('#scorelevelN').find('.levelscore').each(function () {
			var rankText = $(this).val();
			if (rankText == "") {
				rankFlag = "N";
				return false;
			}
		});

		//判断是否有相同的评分范围
		var a = [];//定义一个二维数组
		var minMaxindex = 0;
		var bigflag = ""
		$('#scorelevelN').find('.scoreclassN').each(function () {
			//定义一个一维数组
			var b = [];
			var i = 0;
			//取最小值
			$(this).find('.minscore').each(function () {
				b[i] = $(this).val();
				i++;
			});
			//取最大值
			$(this).find('.maxscore').each(function () {
				b[i] = $(this).val();
				if ((b[i] - 0) < (b[i - 1] - 0)) {
					bigflag = "N"
				}
			});
			a[minMaxindex] = b;
			minMaxindex++;
		})
		var aNary = a.sort();
		var minMaxFlag = "";
		for (p = 0; p < aNary.length; p++) {
			if (JSON.stringify(aNary[p]) == JSON.stringify(aNary[p + 1])) {
				minMaxFlag = "N";
				//return false;
			}
		}
		/*if(bigflag=="N")
		{
			$.messager.alert('错误提示','评分范围内最大值不能小于最小值!',"error");
			return;					
		}
		if(minMaxFlag=="N")
		{
			$.messager.alert('错误提示','分值范围不能重复!',"error");
			return;		
		}*/
		//判断是否有相同的列名
		var nameFlag = ""
		var nameArray = [];
		var nameIndex = 0;
		$('#registerMain').find('.for-just').each(function () {
			var nameId = $(this).attr("id");
			var nameTex = $(this).val();
			if (nameId == undefined) {
				nameArray[nameIndex] = nameTex;
				nameIndex++;
			}
			else {
				nameArray[nameIndex] = nameTex;
				nameIndex++;
			}
		});
		var namenary = nameArray.sort();
		for (i = 0; i < namenary.length; i++) {
			if (namenary[i] == namenary[i + 1]) {
				nameFlag = "N";
			}
		}
		if (nameFlag == "N") {
			$.messager.alert('错误提示', '列名不能重复，请检查！', "error");
			return;
		}
		//判断是否有空的列名
		var nullflag = "";
		var comFlag = "";
		$('#registerMain').find('.hisbox').each(function () {
			var nameId = $(this).attr("id");
			var nameTex = $(this).val();
			if (nameId == undefined) {
				if (nameTex == "") {
					nullflag = "N";
					return false;
				}
			}
			else {
				if (nameTex == "") {
					comFlag = "N"
					return false;
				}
			}
		});
		if (nullflag == "N") {
			$.messager.alert('错误提示', '列名不能为空，请检查！', "error");
			return;
		}
		//判断是否有空的配置项
		if (comFlag == "N") {
			$.messager.alert('错误提示', '配置项不能为空，请检查！', "error");
			return;
		}
		//判断分值项的备注是否相同
		var nodeFlag = "";
		var nodeArray = [];
		var nodeIndex = 0;
		$('#scorelevelN').find('.nodescore').each(function () {
			var node = $(this).val();
			nodeArray[nodeIndex] = node;
			nodeIndex++;
		});
		var nodenary = nodeArray.sort();
		for (i = 0; i < nodenary.length; i++) {
			if (nodenary[i] == nodenary[i + 1]) {
				nodeFlag = "N";
			}
		}
		/*if(nodeFlag=="N")
		{
			$.messager.alert('错误提示','备注不能重复，请检查！',"error");
			return;				
		}*/


		//保存开始		
		$('#form-save').form('submit', {
			url: SAVE_BASE_URL,
			onSubmit: function (param) {
				param.MKBABRowId = id;
			},
			success: function (data) {
				var data = eval('(' + data + ')');
				var newid = data.id;
				if (data.success == 'true') {
					readColumn(newid)//添加成功后，添加扩展列
					if (bigflag != "N" && minMaxFlag != "N" && rangeFlag != "N") {
						readScore(newid)//添加评分范围

					}
					/*$.messager.show({ 
					  title: '提示消息', 
					  msg: '保存成功', 
					  showType: 'show', 
					  timeout: 700, 
					  style: { 
						right: '', 
						bottom: ''
					  } 
					});*/
					$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
					$('#assbasegrid').datagrid('reload');  // 重新载入当前页面数据
					if (flag == 1) {
						setTimeout(function () {
							$('#assbasegrid').datagrid('selectRecord', newid)
							viewAllData();
						}, 100);

					}
					else if (flag == 2) {
						ClearAllData(1)//点击tianjia按钮
					}
				}
				else {
					var errorMsg = "更新失败！"
					if (data.errorinfo) {
						errorMsg = errorMsg + '<br/>错误信息:' + data.errorinfo;
					}
					$.messager.alert('操作提示', errorMsg, "error");

				}

			}
		});

	}
	function readColumn(newid) {
		var id = newid;
		var sequence = 1;
		$('#registerMain').find('.movediv').each(function () {
			//判断扩展列的类型
			var str = id;
			var whole = $(this).attr("id").split("whole")[1];
			var flag = whole.split("A")[2];
			//获取id
			$(this).find('.hiddenRowid').each(function () {
				var rowid = $(this).text();
				//alert(rowid)
				str = str + "&^" + rowid;
			})
			//获取code
			$(this).find('.hiddenCode').each(function () {
				var code = $(this).text();
				str = str + "&^" + code;
			})
			if (flag == "R") {
				var type = "R";
				var Rnum = 1;
				$(this).find('input,textarea').each(function () {
					var name = $(this).attr("class");
					var flagp = !name.match("all");//去掉单选框
					var text = $(this).val();
					if (Rnum == 1) {
						str = str + "&^" + text + "&^" + type + "&^";
						Rnum++;
					}
					else if (flagp && Rnum != 1) {
						if (Rnum % 2 == 0) {
							str = str + text + "[BDP]";
						}
						else if (Rnum % 2 != 0) {
							str = str + text + "&%";
						}
						Rnum++;
					}

				})
				str = str + "&^" + sequence;
				sequence++;
			}
			else if (flag == "C") {
				var type = "C";
				var Cnum = 1;
				$(this).find('input,textarea').each(function () {
					var text = $(this).val();
					//第一个为列名
					if (Cnum == 1) {
						str = str + "&^" + text + "&^" + type + "&^";
						Cnum++;
					}
					else if (Cnum != 1) {
						if (Cnum % 2 == 0) {
							str = str + text + "[BDP]";
						}
						else if (Cnum % 2 != 0) {
							str = str + text + "&%";
						}
						Cnum++;
					}

				})
				str = str + "&^" + sequence;
				sequence++;
			}

			else if (flag == "H") {
				var type = "CB";
				var CBnum = 1;
				$(this).find('input,textarea').each(function () {
					var name = $(this).attr("class");
					var flagp = !name.match("all");//去掉单选框
					var text = $(this).val();
					if (CBnum == 1) {
						str = str + "&^" + text + "&^" + type + "&^";
						CBnum++;
					}
					else if (flagp && CBnum != 1) {
						if (CBnum % 2 == 0) {
							str = str + text + "[BDP]";
						}
						else if (CBnum % 2 != 0) {
							str = str + text + "&%";
						}
						CBnum++;
					}

				})
				str = str + "&^" + sequence;
				sequence++;
			}
			else if (flag == "I") {
				var type = "TX"
				$(this).find('input,textarea').each(function () {
					var text = $(this).val();
					str = str + "&^" + text + "&^" + type + "&^";
				})
				str = str + "&^" + sequence;
				sequence++;
			}
			else if (flag == "T") {
				var type = "TA";
				$(this).find('input,textarea').each(function () {
					var text = $(this).val();
					str = str + "&^" + text + "&^" + type + "&^";
				})
				str = str + "&^" + sequence;
				sequence++;
			}
			var jsonobj2 = eval('(' + tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBaseField", "SaveEntity", str) + ')');
		})
	}
	//添加评分范围
	function readScore(newid) {
		var id = newid;
		//得分
		$('#scorelevelN').find('.scoreclassN').each(function () {
			var str = id;
			//获取id
			$(this).find('.hiddenRowid').each(function () {
				var rowid = $(this).text();
				//alert(rowid)
				str = str + "&^" + rowid;
			})
			//获取code
			$(this).find('.hiddenCode').each(function () {
				var code = $(this).text();
				str = str + "&^" + code;
			})
			//描述
			$(this).find('textarea').each(function () {
				var desc = $(this).val();
				str = str + "&^" + desc;
			})
			//获取最大值最小值和等级
			$(this).find('input').each(function () {
				var thisclass = $(this).attr("class");
				if (thisclass == "minscore") {
					var minvalue = $(this).val();
					str = str + "&^" + minvalue;
				}
				else if (thisclass == "maxscore") {
					var maxvalue = $(this).val();
					str = str + "&^" + maxvalue;
				}
				else if (thisclass = "levelscore") {
					var rank = $(this).val();
					str = str + "&^" + rank;
				}
			})
			var jsonobj = eval('(' + tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentScoringRules", "SaveEntity", str) + ')');
		})
	}
	/*************************************************保存方法结束****************************************************************/
	//右键删除按钮
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssessmentBase&pClassMethod=DeleteData";
	DelBaseData = function () {
		var record = mygrid.getSelected();
		var rowid = record.MKBABRowId;
		var lockFlag = tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase", "AssessmentReadLock", rowid);
		if (lockFlag == "Y") {
			alert("该数据已经锁死，不能删除！")
		}
		else {
			$.messager.confirm('提示', '确定要删除所选数据吗?', function (r) {
				if (r) {
					RefreshSearchData("User.MKBAssessmentBase", rowid, "D", "");//记录频次和历史记录
					$.ajax({
						url: DELETE_ACTION_URL,
						data: { "id": rowid },
						type: "POST",
						success: function (data) {
							var data = eval('(' + data + ')');
							if (data.success == 'true') {
								/*$.messager.show({
									title: '提示消息',
									msg: '删除成功',
									showType: 'show',
									timeout: 1000,
									style: {
										right: '',
										bottom: ''
									}
								});*/
								$.messager.popover({ msg: '保存成功！', type: 'success', timeout: 1000 });
								$('#assbasegrid').datagrid('load', {
									ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
									QueryName: "GetList"
								});
								ClearAllData(1);
								// 重新载入当前页面数据
								$('#assbasegrid').datagrid('unselectAll');  // 清空列表选中数据
							}
							else {
								var errorMsg = "删除失败！";
								if (data.info) {
									errorMsg = errorMsg + '<br/>错误信息:' + data.info;
								}
								$.messager.alert('操作提示', errorMsg, "error");

							}
						}
					})
				}
			})
		}
	}
	//重置方法
	function ClearAllData(flag) {
		$('#form-save').form('clear');//刷新表格
		$('#registerMain').html("");
		$('#scorelevelN').html("");
		document.getElementById('registerMain').innerHTML = "";
		document.getElementById('scorelevelN').innerHTML = "";
		var newrow = "<div class='scoreclassN'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input class='minscore hisui-validatebox' type='text' style='width:60px;'></td><td>-</td><td><input class='maxscore hisui-validatebox'  type='text' style='width:60px;'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input class='levelscore hisui-validatebox'  type='text' style='width:155px;'></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text' style='width:157px;height:50px'  ></textarea></td></tr></table></div>";
		$('#scorelevelN').append(newrow);
		$('.minscore').validatebox();
		$('.maxscore').validatebox();
		$('.levelscore').validatebox({});
		justscore();
		$('.scoreP').text("（0分）");
		$("#TextDesc").combobox('setValue', '');
		if (flag == 1) {
			$('#assbasegrid').datagrid('load', {
				ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
				QueryName: "GetList"
			});
			$('#assbasegrid').datagrid('unselectAll');
			//切换锁死图标和文字
			var sp = $('#btnForbid span span:last'), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
			//sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-lockdata');
			if (!add) {
				$('#btnForbid span span:last').removeClass('icon-unlock');
				$('#btnForbid span span:last').addClass('icon-lockdata');
			}
			$('#btnForbid span span:first').text('锁死');
		}
		else if (flag == 2) {
			$('#assbasegrid').datagrid('load', {
				ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
				QueryName: "GetList"
			});
			viewAllData();
		}
	}
	//重置按钮
	$('#btnRefresh').click(function (e) {
		ClearAllData(2);
	})
	//重置按钮
	$('#btnLeftRefresh').click(function (e) {
		//解锁
		$('#lockForm').unmask()
		//jiesuo工具栏按钮
		$('#addCombobox').linkbutton('enable')
		$('#addCheckbox').linkbutton('enable')
		$('#addRadio').linkbutton('enable')
		$('#addText').linkbutton('enable')
		$('#addTexts').linkbutton('enable')
		$('#btnSave').linkbutton('enable')
		$('#btnRefresh').linkbutton('enable')
		ClearAllData(1);
	})
	//添加小按钮
	$('#btnAddBase').click(function (e) {
		//解锁
		$('#lockForm').unmask()
		//jiesuo工具栏按钮
		$('#addCombobox').linkbutton('enable')
		$('#addCheckbox').linkbutton('enable')
		$('#addRadio').linkbutton('enable')
		$('#addText').linkbutton('enable')
		$('#addTexts').linkbutton('enable')
		$('#btnSave').linkbutton('enable')
		$('#btnRefresh').linkbutton('enable')
		//确认是否保存当前页面
		var record = mygrid.getSelected();
		if (record) {
			var lockFlag = tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase", "AssessmentReadLock", record.MKBABRowId);
			if (lockFlag == "N") {
				$.messager.confirm('提示', '当前数据可能已经修改，如需保存，请点击确定按钮！', function (r) {
					if (r) {
						saveLeftForm(2);
					}
					else {
						ClearAllData(1);
					}
				})

			}
			else {
				ClearAllData(1);
			}
		}
		else {
			/*$.messager.confirm('提示', '是否保存新添加的数据！', function(r){
				if(r)
				{
					saveLeftForm(2);
				}
				else
				{*/
			ClearAllData(1);
			//}		
			//})
		}
	})
	/**************************************************左侧列表显示开始**************************************************************/
	var basecolumns = [[
		{ field: 'MKBABRowId', title: 'RowId', width: 100, hidden: true, sortable: true },
		{ field: 'MKBABCode', title: '代码', width: 100, sortable: true, hidden: true },
		{ field: 'MKBABDesc', title: '标题', width: 100, sortable: true },
		{ field: 'MKBABNote', title: '备注', width: 100, sortable: true, hidden: true }
	]];
	var mygrid = $HUI.datagrid('#assbasegrid', {
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
			QueryName: "GetList"
		},
		width: '100%',
		height: '100%',
		autoRowHeight: true,
		columns: basecolumns,  //列信息
		pagination: true,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize: 15,
		pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
		singleSelect: true,
		remoteSort: false,
		idField: 'MKBABRowId',
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns: true,//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		scrollbarSize: 0,
		onClickRow: function (index, row) {
			viewAllData();
		},
		onRowContextMenu: function (e, rowIndex, row) { //右键时触发事件
			e.preventDefault();//阻止浏览器捕获右键事件
			$(this).datagrid('selectRow', rowIndex);
			var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
			$(
				'<div onclick="DelBaseData()" iconCls="icon-cancel" data-options="">删除</div>'
			).appendTo(mygridmm)
			mygridmm.menu()
			mygridmm.menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		}

	});
	//单机数据显示标题方法
	function viewAllData() {
		var record = mygrid.getSelected();
		if (record) {
			var id = record.MKBABRowId;
			var savedesc = record.MKBABDesc;
			$.cm({
				ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
				QueryName: "GetList",
				rowid: id
			}, function (jsonData) {
				var data = JSON.parse(JSON.stringify(jsonData.rows).substring(1, JSON.stringify(jsonData.rows).length - 1));
				$('#form-save').form("load", data);
				var id = data.MKBABRowId;
				$('#registerMain').html("");
				$('#scorelevelN').html("");
				/*var newrow="<div class='scoreclassN'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input class='minscore hisui-validatebox' type='text' style='width:60px;'></td><td>-</td><td><input class='maxscore hisui-validatebox'  type='text' style='width:60px;'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input class='levelscore hisui-validatebox'  type='text' style='width:155px;'></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text' style='width:157px;height:50px'  ></textarea></td></tr></table></div>";
				 $('#scorelevelN').append(newrow);
				 $('.minscore').validatebox();
				 $('.maxscore').validatebox();
				 $('.levelscore').validatebox({});*/
				//解锁
				$('#lockForm').unmask()
				//jiesuo工具栏按钮
				$('#addCombobox').linkbutton('enable')
				$('#addCheckbox').linkbutton('enable')
				$('#addRadio').linkbutton('enable')
				$('#addText').linkbutton('enable')
				$('#addTexts').linkbutton('enable')
				$('#btnSave').linkbutton('enable')
				$('#btnRefresh').linkbutton('enable')
				//justscore();
				listAllColumn(id);
				//setTimeout(listAllScore(id),300);//为了防止分数范围加载不出来，加上两毫秒秒的延迟
				listAllScore(id);
				var sp = $('#btnForbid span span:last'), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
				//sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-lockdata');
				if (!add) {
					$('#btnForbid span span:last').removeClass('icon-unlock');
					$('#btnForbid span span:last').addClass('icon-lockdata');
				}
				$('#btnForbid span span:first').text('锁死');
				RefreshSearchData("User.MKBAssessmentBase", id, "A", savedesc);//保存用户使用频次和使用记录
			})
		}
	}
	function addComSelect(row, otherrow, insideNum, insidecount) {
		//点击添加小按钮
		$('#addbutton' + row).click(function (e) {
			//var optionrow=insideNum+1;
			var appendrow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'>选项" + insideNum + "</td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
			$('#table' + otherrow).append(appendrow);
			$('#comboNum' + otherrow + 'A' + insideNum).focus();//将光标默认到该行
			hoverTr();
			//输入框变为hisui样式
			$('.hisbox').validatebox({});
			$('.socerclass').validatebox({});
			addAllscoreN();
			insideNum++;
			insidecount++;
		})
		//点击添加多行按钮
		$('#addmuch' + row).click(function (e) {
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin", {
				iconCls: 'icon-addlittle',
				resizable: true,
				title: '添加多条',
				modal: true,
				buttonAlign: 'center',
				buttons: [{
					text: '保存',
					id: 'save_btn',
					handler: function () {
						var len = ($('#buttons').val()).split("\n").length;
						for (i = 0; i < len; i++) {

							var str = ($('#buttons').val()).split("\n")[i];
							if (str != "") {
								var optionrow = insideNum + 1;
								var appendrow = "<tr class='hovertr' id='option" + otherrow + "A" + optionrow + "'><td  align='right'>选项" + insideNum + "</td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "'  type='text'>"+str+"</textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
								$('#table' + otherrow).append(appendrow);
								hoverTr()
								//输入框变为hisui样式
								$('.hisbox').validatebox({});
								$('.socerclass').validatebox({});
								addAllscoreN();
								insideNum++;
								insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						myWin.close();
					}
				}]
			});
		})
	}
	function addRadSelect(row, otherrow, insideNum, insidecount) {
		$('#addbutton' + row).click(function (e) {
			//addcheck(insideNum,otherrow);
			//var optionrow=insideNum+1;	
			var appendrow = "<tr class='hovertr'  id='option" + otherrow + "A" + insideNum + "'><td align='right'><input name='radio" + otherrow + "' class='allRadio' type='radio' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "' type='text' placeholder='选项" + insideNum + "'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
			$('#table' + otherrow).append(appendrow);
			$('#comboNum' + otherrow + 'A' + insideNum).focus();//将光标默认到该行
			hoverTr();
			//输入框变为hisui样式
			$('.hisbox').validatebox({});
			$('.socerclass').validatebox({});
			addAllscoreN()
			//将单选框渲染成hisui样式
			$HUI.radio('.allRadio', {
			});
			insideNum++;
			insidecount++;
		})
		//点击添加多行按钮
		$('#addmuch' + row).click(function (e) {
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin", {
				iconCls: 'icon-addlittle',
				resizable: true,
				title: '添加多条',
				modal: true,
				buttonAlign: 'center',
				buttons: [{
					text: '保存',
					id: 'save_btn',
					handler: function () {
						//alert(($('#buttons').val()).split("\n")[1])
						var len = ($('#buttons').val()).split("\n").length;
						for (i = 0; i < len; i++) {

							var str = ($('#buttons').val()).split("\n")[i];
							if (str != "") {
								var optionrow = insideNum + 1;
								var appendrow = "<tr class='hovertr' id='option" + otherrow + "A" + optionrow + "'><td  align='right'><input name='radio" + otherrow + "' class='allRadio' type='radio' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "' type='text' >"+str+"</textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
								$('#table' + otherrow).append(appendrow);
								hoverTr();
								//输入框变为hisui样式
								$('.hisbox').validatebox({});
								$('.socerclass').validatebox({});
								addAllscoreN();
								//将单选框渲染成hisui样式
								$HUI.radio('.allRadio', {
								});
								insideNum++;
								insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						myWin.close();
					}
				}]
			});
		})

	}
	function addCheckSelected(row, otherrow, insideNum, insidecount) {
		$('#addbutton' + row).click(function (e) {
			//var optionrow=insideNum+1;
			var appendrow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'><input name='checkbox" + otherrow + "' class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "'  placeholder='选项" + insideNum + "' type='text'></textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
			$('#table' + otherrow).append(appendrow);
			$('#comboNum' + otherrow + 'A' + insideNum).focus();//将光标默认到该行
			hoverTr();
			//输入框变为hisui样式
			$('.hisbox').validatebox();
			$('.socerclass').validatebox();
			addAllscoreN();
			//将duo选框渲染成hisui样式
			// $HUI.checkbox('.allCheck',{
			// });
			insideNum++;
			insidecount++;
		})
		//点击添加多行按钮
		$('#addmuch' + row).click(function (e) {
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin", {
				iconCls: 'icon-addlittle',
				resizable: true,
				title: '添加多条',
				modal: true,
				buttonAlign: 'center',
				buttons: [{
					text: '保存',
					id: 'save_btn',
					handler: function () {
						//alert(($('#buttons').val()).split("\n")[1])
						var len = ($('#buttons').val()).split("\n").length;
						for (i = 0; i < len; i++) {

							var str = ($('#buttons').val()).split("\n")[i];
							if (str != "") {
								var optionrow = insideNum + 1;
								var appendrow = "<tr class='hovertr' id='option" + otherrow + "A" + optionrow + "'><td  align='right'><input name='checkbox" + otherrow + "' class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "'  type='text'>"+str+"</textarea></td><td></td><td style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text'></td><td class='childhover'></td></tr>";
								$('#table' + otherrow).append(appendrow);
								hoverTr();
								//输入框变为hisui样式
								$('.hisbox').validatebox();
								$('.socerclass').validatebox();
								addAllscoreN();
								//将duo选框渲染成hisui样式
								// $HUI.checkbox('.allCheck',{
								// });
								insideNum++;
								insidecount++;
							}
						}
						$('#buttons').val("");
						myWin.close();
					}
				}, {
					text: '关闭',
					handler: function () {
						myWin.close();
					}
				}]
			});
		})
	}
	//显示所有列属性
	function listAllColumn(id) {
		$.cm({
			ClassName: "web.DHCBL.MKB.MKBAssessmentBaseField",
			QueryName: "GetList",
			base: id
		}, function (jsonData) {
			for (var j = 0, len = jsonData.rows.length; j < len; j++) {
				var MKBABFDesc = jsonData.rows[j].MKBABFDesc;
				var MKBABFType = jsonData.rows[j].MKBABFType;
				var MKBABFConfig = jsonData.rows[j].MKBABFConfig;
				var MKBABFSequence = jsonData.rows[j].MKBABFSequence;
				var MKBABFRowId = jsonData.rows[j].MKBABFRowId;
				var MKBABFCode = jsonData.rows[j].MKBABFCode;
				var insideNum = 1;
				var insidecount = 1;//记录条数
				var otherrow = row;
				if (MKBABFType == "C") {
					//下拉框
					var newDiv = "<div class='movediv' id='wholeA" + row + "AC' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  align='center' style='float:left;padding:10px 10px 10px 1px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + MKBABFDesc + "'></td><td>（下拉框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//输入框变为hisui样式
					$('.hisbox').validatebox({
					});
					//插入单条按钮
					var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td style='display:none' class='addhover'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>"
					$('#divID' + row).append(newbutton);
					//插入多条按钮
					var muchbutton = "<td style='display:none' class='addhover' style='padding-left:10px'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>"
					$('#toolstr' + row).append(muchbutton);
					moveAll();
					var newArray = MKBABFConfig.split("&%");
					for (var i = 0; i < newArray.length - 1; i++) {
						var indexC = newArray[i];
						var field = indexC.split("[BDP]")[0];
						var score = indexC.split("[BDP]")[1];
						var addRow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'>选项" + insideNum + "</td><td><textarea style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "' type='text'>"+field+"</textarea></td><td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + score + "'></td><td class='childhover'></td></tr>";
						$('#table' + otherrow).append(addRow);
						//alert($('#table'+otherrow).attr("id"))
						hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						$('.socerclass').validatebox();
						insideNum++;
						insidecount++;
					}
					addComSelect(row, otherrow, insideNum, insidecount);
					addAllscoreN();
					$('#wholeA' + row + "AC").find('.hiddenRowid').each(function () {
						$(this).text(MKBABFRowId);
					})
					$('#wholeA' + row + "AC").find('.hiddenCode').each(function () {
						$(this).text(MKBABFCode);
					})
					row++;
					sortP();

				}
				else if (MKBABFType == "R") {
					//单选框
					var newDiv = "<div class='movediv' id='wholeA" + row + "AR' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + MKBABFDesc + "'></td><td>（单选框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//输入框变为hisui样式
					$('.hisbox').validatebox({
					});
					//插入单条按钮
					var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
					$('#divID' + row).append(newbutton);
					//插入多条按钮
					var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
					$('#toolstr' + row).append(muchbutton);
					moveAll();
					var newArray = MKBABFConfig.split("&%");
					for (var i = 0; i < newArray.length - 1; i++) {
						var indexC = newArray[i];
						var field = indexC.split("[BDP]")[0];
						var score = indexC.split("[BDP]")[1];
						var addRow = "<tr class='hovertr' id='option" + otherrow + "a" + insideNum + "'><td  align='right'><input name='radio" + otherrow + "' type='radio' class='allRadio' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "' type='text' >" + field + "</textarea></td><td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + score + "'></td><td class='childhover'></td></tr>";
						$('#table' + otherrow).append(addRow);
						hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						$('.socerclass').validatebox({});
						insideNum++;
						insidecount++;
					}
					addRadSelect(row, otherrow, insideNum, insidecount);
					//将单选框渲染成hisui样式
					$HUI.radio('.allRadio', {});
					addAllscoreN();
					$('#wholeA' + row + "AR").find('.hiddenRowid').each(function () {
						$(this).text(MKBABFRowId);
					})
					$('#wholeA' + row + "AR").find('.hiddenCode').each(function () {
						$(this).text(MKBABFCode);
					})
					row++;
					sortP();

				}
				else if (MKBABFType == "CB") {
					//复选框
					var newDiv = "<div class='movediv'  id='wholeA" + row + "AH' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'  style='float:left;padding:10px;border-left:#40a2de solid 0px'><table cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:200px;' type='text' value='" + MKBABFDesc + "'></td><td>（复选框）</td><td style='padding-left:50px'>评分</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					$('.hisbox').validatebox({
					});
					//插入单条按钮
					var newbutton = "<table align='left' style='padding-left:10px'><tr id='toolstr" + row + "'><td class='addhover' style='display:none'><img id='addbutton" + row + "' src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png'  style='border:0px;cursor:pointer'></td></tr></table>";
					$('#divID' + row).append(newbutton);
					//插入多条按钮
					var muchbutton = "<td style='padding-left:10px' class='addhover' style='display:none'><img id='addmuch" + row + "' style='display:none' class='addhover' src='../scripts/bdp/Framework/icons/mkb/add_list.png' style='border:0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>";
					$('#toolstr' + row).append(muchbutton);
					moveAll();
					//点击添加小按钮
					var newArray = MKBABFConfig.split("&%");
					for (var i = 0; i < newArray.length - 1; i++) {
						var indexC = newArray[i];
						var field = indexC.split("[BDP]")[0];
						var score = indexC.split("[BDP]")[1];
						var addRow = "<tr class='hovertr' id='option" + otherrow + "A" + insideNum + "'><td  align='right'><input name='checkbox" + otherrow + "' class='allCheck' type='checkbox' value=''></td><td><textarea class='hisbox' style='width:200px;height:28px' id='comboNum" + otherrow + "A" + insideNum + "'   type='text'>" + field + "</textarea></td><td></td><td id='" + insideNum + "'style='padding-left:50px'><input class='socerclass' style='width:100px;' type='text' value='" + score + "'></td><td class='childhover'></td></tr>";
						$('#table' + otherrow).append(addRow);
						hoverTr();
						//输入框变为hisui样式
						$('.hisbox').validatebox({
						});
						$('.socerclass').validatebox();
						insideNum++;
						insidecount++;
					}
					addCheckSelected(row, otherrow, insideNum, insidecount)
					//将duo选框渲染成hisui样式
					// $HUI.checkbox('.allCheck',{
					// });
					addAllscoreN();
					$('#wholeA' + row + "AH").find('.hiddenRowid').each(function () {
						$(this).text(MKBABFRowId);
					})
					$('#wholeA' + row + "AH").find('.hiddenCode').each(function () {
						$(this).text(MKBABFCode);
					})
					row++;
					sortP();
				}
				else if (MKBABFType == "TX") {
					//单行文本
					var newDiv = "<div class='movediv' id='wholeA" + row + "AI' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text' value='" + MKBABFDesc + "'></td><td>（单行文本）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					moveAll();
					$('.hisbox').validatebox({
					});
					$('#wholeA' + row + "AI").find('.hiddenRowid').each(function () {
						$(this).text(MKBABFRowId);
					})
					$('#wholeA' + row + "AI").find('.hiddenCode').each(function () {
						$(this).text(MKBABFCode);
					})
					row++;
					sortP();

				}
				else if (MKBABFType == "TA") {
					//多行文本
					//多行文本
					var newDiv = "<div class='movediv' id='wholeA" + row + "AT' style='margin:10px 10px 10px 10px;width:98%;overflow:hidden;height:180px;border:1px solid #C0C0C0'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><div class='allbarclass' style='float:left;height:100%;width:7%;' align='center' ><p style='margin:10px;background-color:#00BB00;color:white;border-radius:5px 5px 5px 5px;'>Q" + row + "</p></div><div class='classChild' id='divID" + row + "'   style='float:left;padding:10px;border-left:#40a2de solid 0px'><table  cellspacing='10' id='table" + row + "'><tr id='option" + row + "A1'><td  align='right'>列名</td><td><input class='hisbox for-just' id='positionId" + row + "' style='width:250px;' type='text' value='" + MKBABFDesc + "'></td><td>（多行文本）</td></tr></table></div></div>";
					$('#registerMain').append(newDiv);
					//添加新扩展列跳转
					moveAll();
					$('.hisbox').validatebox({
					});
					$('#wholeA' + row + "AT").find('.hiddenRowid').each(function () {
						$(this).text(MKBABFRowId);
					});
					$('#wholeA' + row + "AT").find('.hiddenCode').each(function () {
						$(this).text(MKBABFCode);
					});
					row++;
					sortP();
				}
			}
			//setTimeout(replayscore(),200);
			replayscore();
		})
	}
	//重新排序标签
	function sortP() {
		//将列的标签重新命名
		var num = 1;
		$('#registerMain').find('p').each(function () {
			$(this).text("Q" + num);
			num++;
		})
	}
	//显示评分规则
	function listAllScore(id) {
		$.cm({
			ClassName: "web.DHCBL.MKB.MKBAssessmentScoringRules",
			QueryName: "GetList",
			base: id
		}, function (jsonData) {
			$('#scorelevelN').html("");
			for (var j = 0, len = jsonData.rows.length; j < len; j++) {
				var MKBASRRowId = jsonData.rows[j].MKBASRRowId;
				var MKBASRCode = jsonData.rows[j].MKBASRCode;
				var MKBASRDesc = jsonData.rows[j].MKBASRDesc;
				var MKBASRMinValue = jsonData.rows[j].MKBASRMinValue;
				var MKBASRMaxValue = jsonData.rows[j].MKBASRMaxValue;
				var MKBASRRank = jsonData.rows[j].MKBASRRank;
				//console.log(MKBASRMinValue)
				if (j == 0) {
					//setTimeout(function(){
					var newrow = "<div class='scoreclassN'><div><div class='hiddenRowid' style='display:none'>" + MKBASRRowId + "</div><div class='hiddenCode' style='display:none'>" + MKBASRCode + "</div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input class='minscore' id='minscore" + j + "' value='" + MKBASRMinValue + "' type='text' style='width:60px;'></input></td><td>-</td><td><input value='" + MKBASRMaxValue + "' id='maxscore" + j + "' class='maxscore'  type='text' style='width:60px;'></input></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input class='levelscore'  value='" + MKBASRRank + "' type='text' style='width:155px;'></input></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text'style='width:157px;height:50px'  >" + MKBASRDesc + "</textarea></td></tr></table></div>";
					$('#scorelevelN').append(newrow);
					$('.minscore').validatebox();
					$('.maxscore').validatebox();
					$('.levelscore').validatebox({});
					//$('#minscore'+j).val(MKBASRMinValue);
					//$('#maxscore'+j).val(MKBASRMaxValue);							
					//},50)
				}
				else {

					//setTimeout(function(){
					var newrow = "<div class='scoreclassN' style='border-top:1px dashed #C0C0C0;'><div><div class='hiddenRowid' style='display:none'>" + MKBASRRowId + "</div><div class='hiddenCode' style='display:none'>" + MKBASRCode + "</div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input value='" + MKBASRMinValue + "' id='minscore" + j + "' class='minscore' type='text' style='width:60px;'></input></td><td>-</td><td><input class='maxscore' id='maxscore" + j + "' value='" + MKBASRMaxValue + "' type='text' style='width:60px;'></input></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' onclick='delLevel(this)' style='border: 0px;cursor:pointer'></td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input value='" + MKBASRRank + "' class='levelscore'  type='text' style='width:155px;'></input></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text' style='width:157px;height:50px'>" + MKBASRDesc + "</textarea></td></tr></table></div>";
					$('#scorelevelN').append(newrow);
					$('.minscore').validatebox();
					$('.maxscore').validatebox();
					$('.levelscore').validatebox({});
					//$('#minscore'+j).val(MKBASRMinValue);
					//$('#maxscore'+j).val(MKBASRMaxValue);							 
					//},50)
				}
			}
			if (jsonData.rows.length==0) {
				var newlevel = "<div class='scoreclassN' style='border-top:1px dashed #C0C0C0;'><div><div class='hiddenRowid' style='display:none'></div><div class='hiddenCode' style='display:none'></div></div><table style='padding-top:10px' cellspacing='10' align='center'><tr><td align='right'>评分范围</td><td><input class='minscore' type='text' style='width:60px;'></td><td>-</td><td><input class='maxscore'  type='text' style='width:60px;'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' onclick='addNewLevel()' style='border: 0px;cursor:pointer'></td><td><img  src='../scripts_lib/hisui-0.1.0/dist/css/icons/no.png' onclick='delLevel(this)' style='border: 0px;cursor:pointer'></td></tr><tr><td align='right'>评分等级</td><td colspan='5'><input class='levelscore'  type='text' style='width:155px;'></td></tr><tr><td align='right'>备注</td><td colspan='5'><textarea class='nodescore' type='text' style='width:157px;height:50px'  ></textarea></td></tr></table></div>"
				$('#scorelevelN').append(newlevel);
				$('.minscore').validatebox();
				$('.maxscore').validatebox();
				$('.levelscore').validatebox({});
			}
			justscore();
			var lockFlag = tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase", "AssessmentReadLock", id);
			if (lockFlag == "Y") {
				$('#btnForbid span span:last').removeClass('icon-lockdata');
				$('#btnForbid span span:last').addClass('icon-unlock');
				$('#btnForbid span span:first').text('解锁');
				//setTimeout(lockMethod(),100)
				$('#lockForm').mask('').click(function () {
					/*$.messager.show({ 
						  title: '提示消息', 
						  msg: '该条数据已经锁死，不允许进行任何操作！！', 
						showType: 'show', 
						timeout: 700, 
						  style: { 
					  right: '', 
					  bottom: ''
						  } 
				  });*/
					$.messager.popover({ msg: '该条数据已经锁死，不允许进行任何操作！', type: 'alert' });
				})
				//遮罩评分规则
				$('#scorelevelN').find('.scoreclassN').each(function () {
					$(this).mask('').click(function () {
						/*$.messager.show({ 
							  title: '提示消息', 
							  msg: '该条数据已经锁死，不允许进行任何操作！！', 
							showType: 'show', 
							timeout: 700, 
							  style: { 
						  right: '', 
						  bottom: ''
							  } 
					  }); */
						$.messager.popover({ msg: '该条数据已经锁死，不允许进行任何操作！', type: 'alert' });
					})
				})
				//遮罩扩展列
				$('#registerMain').find('.movediv').each(function () {
					$(this).mask('').click(function () {
						/*$.messager.show({ 
							  title: '提示消息', 
							  msg: '该条数据已经锁死，不允许进行任何操作！！', 
							showType: 'show', 
							timeout: 700, 
							  style: { 
						  right: '', 
						  bottom: ''
							  } 
					  });*/
						$.messager.popover({ msg: '该条数据已经锁死，不允许进行任何操作！', type: 'alert' });
					})
				})
				//禁用工具栏按钮
				$('#addCombobox').linkbutton('disable')
				$('#addCheckbox').linkbutton('disable')
				$('#addRadio').linkbutton('disable')
				$('#addText').linkbutton('disable')
				$('#addTexts').linkbutton('disable')
				$('#btnSave').linkbutton('disable')
				$('#btnRefresh').linkbutton('disable')
			}
		})
	}
	//查询按钮
	/*$("#TextDesc").searchbox({
		searcher:function(value,name){
			SearchMapBase();
		}
	})*/
	$('#TextDesc').searchcombobox({
		url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBAssessmentBase",
		onSelect: function () {
			$(this).combobox('textbox').focus();
			SearchMapBase()

		}
	});
	$('#TextDesc').combobox('textbox').bind('keyup', function (e) {
		if (e.keyCode == 13) {
			SearchMapBase()
		}
	});

	$("#btnSearch").click(function (e) {
		SearchMapBase();
	})
	//查询方法
	function SearchMapBase() {
		var desc = $("#TextDesc").combobox('getText');
		$('#assbasegrid').datagrid('load', {
			ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
			QueryName: "GetList",
			'desc': desc
		});
	}
	/**************************************************左侧列表显示结束**************************************************************/
	//点击预览按钮
	$('#btnpreview').click(function (e) {
		//选中一条数据
		var record = mygrid.getSelected();
		if (record) {
			var rowid = record.MKBABRowId;
			//$.messager.confirm('提示', '数据可能已经发生变动吗，需要保存后预览吗?', function(r){
			//	if(r)
			//	{
			var url="dhc.bdp.mkb.mkbassessment.csp?id=" + rowid + "&sdflag=Y"
			if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken()
			}
			$("#preWin").show();
			var myWin = $HUI.window("#preWin", {
				iconCls: 'icon-w-eye',
				resizable: true,
				title: '预览',
				width:1300, 
				height:(document.body.clientHeight-40),  //根据浏览器高度
				modal: true,
				maximizable: false,
				minimizable: false,
				collapsible: false,
				content: '<iframe id="prewindow" frameborder="0" src="'+url+'" width="99%" height="99%"></iframe>',
				buttonAlign: 'center'
			});
			//	}
			//})
		}
		else {
			$.messager.alert('错误提示', '请先选择一条记录!', "error");
			return;
		}

	})
	//锁死
	$('#btnForbid').click(function (e) {
		//lockMethod();
		//var sp = $('span:last', this), add = sp.hasClass('icon-lockdata');//$(this).find($('span'))
		//sp[add ? 'removeClass' : 'addClass']('icon-lockdata')[add ? 'addClass' : 'removeClass']('icon-unlock');
		var locktext = $('#btnForbid span span:first').text();
		if (locktext == "锁死") {
			//$('#btnForbid span span:first').text('解锁');
			lockMethod();
		}
		else {
			//$('#btnForbid span span:first').text('锁死');
			$("#lockWin").show();
			var lockWin = $HUI.dialog("#lockWin", {
				iconCls: 'icon-unlock',
				resizable: true,
				title: '解锁',
				modal: true,
				buttonAlign: 'center',
				buttons: [{
					text: '确定',
					id: 'save_lock',
					handler: function () {
						justPassword();

					}
				},
				{
					text: '取消',
					handler: function () {
						$('#lockpassword').val('')
						lockWin.close();
					}
				}]
			});

		}
		$('#lockpassword').focus();
	});
	//给密码框绑定回车事件
	$("#lockpassword").keypress(function (event) {
		if (event.which === 13) {
			//点击回车要执行的事件
			justPassword();
		}
	})
	//解锁方法
	function justPassword() {
		var password = $('#lockpassword').val();
		var record = mygrid.getSelected();
		if (record) {
			//var pass=tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase","findPassWord");		
			if (password == "admin") {
				var id = record.MKBABRowId;
				tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase", "unLockMethod", id);
				$('#lockpassword').val('')
				$('#lockWin').dialog('close');
				viewAllData();
			}
			else {
				$.messager.alert('错误提示', '输入正确的密码!', "error");
				return;
			}
		}
	}
	//锁死方法
	function lockMethod() {
		var record = mygrid.getSelected();
		if (record) {
			var id = record.MKBABRowId;
			tkMakeServerCall("web.DHCBL.MKB.MKBAssessmentBase", "AssessmentLock", id);
			/*$.messager.show({ 
			  title: '提示消息', 
			  msg: '操作成功！', 
			  showType: 'show', 
			  timeout: 700, 
			  style: { 
				right: '', 
				bottom: ''
			  } 
			});*/
			$.messager.popover({ msg: '操作成功！', type: 'success', timeout: 1000 });
			viewAllData();
		}
		else {
			$.messager.alert('错误提示', '请先选择一条记录!', "error");
			return;
		}
	}
	/**
	*
	*锁死的遮罩层，引用网上封装的方法
	**/
	$.extend($.fn, {
		mask: function (msg, maskDivClass) {
			this.unmask();
			// 参数
			var op = {
				opacity: 0.8,
				z: 10000,
				bgcolor: '#ffffff'
			};
			var original = $(document.body);
			var position = { top: 0, left: 0 };
			if (this[0] && this[0] !== window.document) {
				original = this;
				position = original.position();
			}
			// 创建一个 Mask 层，追加到对象中
			var maskDiv = $('<div class="maskdivgen"> </div>');
			maskDiv.appendTo(original);
			var maskWidth = original.outerWidth();
			if (!maskWidth) {
				maskWidth = original.width();
			}
			var maskHeight = original.outerHeight();
			if (!maskHeight) {
				maskHeight = original.height();
			}
			maskDiv.css({
				position: 'absolute',
				top: position.top,
				left: position.left,
				'z-index': op.z,
				width: maskWidth,
				height: maskHeight,
				'background-color': '',
				opacity: 0
			});
			if (maskDivClass) {
				maskDiv.addClass(maskDivClass);
			}
			if (msg) {
				var msgDiv = $('<div style="position:absolute;border:#6593cf 1px solid; padding:2px;background:#ccca"><div style="line-height:24px;border:#a3bad9 1px solid;background:white;padding:2px 10px 2px 10px">' + msg + '</div></div>');
				msgDiv.appendTo(maskDiv);
				var widthspace = (maskDiv.width() - msgDiv.width());
				var heightspace = (maskDiv.height() - msgDiv.height());
				msgDiv.css({
					cursor: 'wait',
					top: (heightspace / 2 - 2),
					left: (widthspace / 2 - 2)
				});
			}
			maskDiv.fadeIn('fast', function () {
				// 淡入淡出效果
				$(this).fadeTo('slow', op.opacity);
			})
			return maskDiv;
		},
		unmask: function () {
			var original = $(document.body);
			if (this[0] && this[0] !== window.document) {
				original = $(this[0]);
			}
			original.find("> div.maskdivgen").fadeOut('slow', 0, function () {
				$(this).remove();
			});
		}
	});
	///disable和enable覆盖重写
	/**
	 * linkbutton方法扩展
	 * @param {Object} jq
	$.extend($.fn.linkbutton.methods, {
		enable: function(jq){
			return jq.each(function(){
				var state = $.data(this, 'linkbutton');
				if ($(this).hasClass('l-btn-disabled')) {
					var itemData = state._eventsStore;
					//恢复超链接
					if (itemData.href) {
						$(this).attr("href", itemData.href);
					}
					//回复点击事件
					if (itemData.onclicks) {
						for (var j = 0; j < itemData.onclicks.length; j++) {
							$(this).bind('click', itemData.onclicks[j]);
						}
					}
					//设置target为null，清空存储的事件处理程序
					itemData.target = null;
					itemData.onclicks = [];
					$(this).removeClass('l-btn-disabled');
				}
			});
		},
		/**
		 * 禁用选项（覆盖重写）
		 * @param {Object} jq
		disable: function(jq){
			return jq.each(function(){
				var state = $.data(this, 'linkbutton');
				if (!state._eventsStore)
					state._eventsStore = {};
				if (!$(this).hasClass('l-btn-disabled')) {
					var eventsStore = {};
					eventsStore.target = this;
					eventsStore.onclicks = [];
					//处理超链接
					var strHref = $(this).attr("href");
					if (strHref) {
						eventsStore.href = strHref;
						$(this).attr("href", "javascript:void(0)");
					}
					//处理直接耦合绑定到onclick属性上的事件
					var onclickStr = $(this).attr("onclick");
					if (onclickStr && onclickStr != "") {
						eventsStore.onclicks[eventsStore.onclicks.length] = new Function(onclickStr);
						$(this).attr("onclick", "");
					}
					//处理使用jquery绑定的事件
					var eventDatas = $(this).data("events") || $._data(this, 'events');
					if (eventDatas["click"]) {
						var eventData = eventDatas["click"];
						for (var i = 0; i < eventData.length; i++) {
							if (eventData[i].namespace != "menu") {
								eventsStore.onclicks[eventsStore.onclicks.length] = eventData[i]["handler"];
								$(this).unbind('click', eventData[i]["handler"]);
								i--;
							}
						}
					}
					state._eventsStore = eventsStore;
					$(this).addClass('l-btn-disabled');
				}
			});
		}
	});*/

}
$(init);
