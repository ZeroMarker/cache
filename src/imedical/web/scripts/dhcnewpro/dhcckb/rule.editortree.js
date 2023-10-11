var _json
var _json=[{"ruleId":61466,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1204559"},"type":"variable","ruleData":"1204559"},"value":{"constantCategory":"22136","constantName":"22136","constantLabel":"新生儿（早产儿）","valueType":"Constant","ruleData":"1204559"},"op":"Equals","ruleData":"1204559"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1204560"},"type":"variable","ruleData":"1204560"},"value":{"content":"1","contentUom":"4501","contentUomDesc":"日","contentLimit":"7","valueType":"InputLimit","ruleData":"1204560"},"op":"Between","ruleData":"1204560"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1204561"},"type":"variable","ruleData":"1204561"},"value":{"content":"3","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1204561"},"op":"LessThenEquals","ruleData":"1204561"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1204562"},"type":"variable","ruleData":"1204562"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1204562"},"op":"Equals","ruleData":"1204562"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204563"},"type":"variable","ruleData":"1204563"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1204563"},"op":"Equals","ruleData":"1204563"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204564"},"type":"variable","ruleData":"1204564"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1204564"},"op":"Equals","ruleData":"1204564"}],"ruleData":"893150"}],"ruleData":893149}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1204565"},"ruleData":"1204565"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1204566"},"ruleData":"1204566"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"早产儿：每次按体重3万单位/kg，出生第一周每12小时1次，2~4周者每8小时1次；以后每6小时1次。"},"ruleData":"1204567"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1204568"},"ruleData":"1204568"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1204569"},"ruleData":"1204569"}]}}]}]
var selectBox = [{"value":"and","text":'并且'}, {"value":"or","text":'或者'}, {"value":"union","text":'联合'}, {"value":"additem","text":'添加条件'}, {"value":"addunionitem","text":'添加联合条件'}, {"value":"del","text":'删除'}];
var attrsels = "";   //动态面板选择对象
function initPageDefault()
{
	/*alert($("#test").offset().top)
	alert($("#test").offset().left)
	alert($("#test").width())
	alert($("#test").height())*/
	
	//Part2st 那么
	var rhs=_json[0].rules[0].rhs.actions;
	var htmlTwo="<div id='then' style='padding: 5px;' class='ui-sortable'>"
	for (i=0; i<rhs.length; i++) {
		 htmlTwo=htmlTwo+"<div class='rule-action' id='"+rhs[i].ruleData+"' data_type='"+rhs[i].value.valueType+"'>" //2020-12-03 data_type
		 htmlTwo=htmlTwo+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		 htmlTwo=htmlTwo+"<span>"//2020-12-03 add
		 htmlTwo=htmlTwo+" <span class='line-green'>变量赋值:</span>"
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+" <span class='line-darkcyan-zero' par_data='"+rhs[i].variableCategoryId+"' data_id='"+rhs[i].variableName+"'>"+rhs[i].variableCategory+"的"+rhs[i].variableLabel+"</span>"
		 htmlTwo=htmlTwo+" <span style='color: red;'>=</span>"
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+" <span>"//2020-12-03 add
		 if(rhs[i].value.valueType=="Constant"){
			htmlTwo=htmlTwo+" <span class='line-blue' onclick='chooseDataset(this,1)' data_id='"+rhs[i].value.constantName+"'>"+rhs[i].value.constantLabel+"</span>"
		 }else{
			//htmlTwo=htmlTwo+" <span class='line-brown'>"+rhs[i].value.content+"</span>"
			var conValue=rhs[i].value.content;
			htmlTwo=htmlTwo+"	<span class='line-brown' onclick='viewInput(this)'>"+conValue+"</span>"
			htmlTwo=htmlTwo+"	<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>"
		 }
		 htmlTwo=htmlTwo+" </span>"//2020-12-03 add
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+"</span>"//2020-12-03 add
		 htmlTwo=htmlTwo+"</div>";
	}
	htmlTwo=htmlTwo+"</div>"			  
	$("#actionNode").append(htmlTwo);
	
	//Part3st 否则
	var other=_json[0].rules[0].other.actions;
	var htmlThr="<div id='else' style='padding: 5px' class='ui-sortable'>"	    
	for (i=0; i<other.length; i++) {
		htmlThr=htmlThr+"<div class='rule-action' id='"+other[i].ruleData+"' data_type='"+other[i].value.valueType+"'>"
		htmlThr=htmlThr+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		htmlThr=htmlThr+"<span>"//2020-12-03 add
		htmlThr=htmlThr+"  <span class='line-green' style='color:red'>变量赋值:</span>"
		htmlThr=htmlThr+"  <span class='blank'>.</span>"
		htmlThr=htmlThr+"  <span class='line-darkcyan-zero' par_data='"+other[i].variableCategoryId+"' data_id='"+other[i].variableName+"'>"+other[i].variableCategory+"的"+other[i].variableLabel+"</span>"
		htmlThr=htmlThr+"  <span style='color: red;'>=</span>"
		htmlThr=htmlThr+"  <span class='blank'>.</span>"
		htmlThr=htmlThr+"  <span>"//2020-12-03 add
		if(other[i].value.valueType=="Constant"){
			htmlThr=htmlThr+" <span class='line-blue' onclick='chooseDataset(this,1)' data_id='"+other[i].value.constantName+"'>"+other[i].value.constantLabel+"</span>"
		}else{
			//htmlThr=htmlThr+" <span class='line-brown'>"+other[i].value.content+"</span>"
			var conValue=other[i].value.content;
			htmlThr=htmlThr+"	<span class='line-brown' onclick='viewInput(this)'>"+conValue+"</span>"
			htmlThr=htmlThr+"	<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>"
		}
		htmlThr=htmlThr+"  </span>"//2020-12-03 add
		htmlThr=htmlThr+"<span class='blank'>.</span>"
		htmlThr=htmlThr+"</span>"//2020-12-03 add
		htmlThr=htmlThr+"  </div>"
	}
	htmlThr=htmlThr+" </div>"
 	htmlThr=htmlThr+"</div>"
	$("#actionNode").append(htmlThr);



 $("body").on('dblclick',function(e){
 	AllUlPanel();
 });

}

function chooseVar(attr){
	AllUlPanel()
	$("#drugattr").css("display","block");
	$("#drugattr").css("left",$(attr).offset().left);
	$("#drugattr").css("top",$(attr).offset().top+$(attr).height());
	attrsels = attr;
}

///选择比较操作符面板浮现
function chooseOpera(Opera){
	AllUlPanel();
	$("#operation").css("display","block");
	$("#operation").css("left",$(Opera).offset().left);
	$("#operation").css("top",$(Opera).offset().top+$(Opera).height());
	$(Opera).attr("id","OperaActive");
}

//输入值类型面板浮现
function chooseType(Type,value){
	AllUlPanel();
	$("#inputType").css("display","block");
	$("#inputType").css("left",$(Type).offset().left);
	$("#inputType").css("top",$(Type).offset().top+$(Type).height());
	$(Type).attr("id","TypeActive");
	
	//var dataId = $(Type).prev().prev().attr("data_id");//2020-12-11 st
	if(value==1){ //2021-03-04 st
		var dataId = $(Type).prev().prev().attr("data_id");
	}else{
		var dataId = $(Type).parent().parent().prev().find(".line-darkcyan").attr("data_id");//2021-03-01
	}//ed
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttrFlag",{"attrId":dataId});//ed
	if(value==1){//2020-12-03 then/else只选输入值和数据集,原因：原图谱的输入单位、上下线不可用,且当前满足需要
		if(html!=""){
			TypeActive('I5',1); //2021-03-04 第二个参数1代表是动作那么否则的数据集选择，其结构和条件不再相同
		}else{
			TypeActive('I1');
		}
	}else{
		if($(Type).prev().attr("data")=="Between"){
			TypeActive('I3');
		}else{
			if(html!=""){
				TypeActive('I5');
			}else{
				$("#inputType").find("a[data='2']").css("display","block");
				$("#inputType").find("a[data='3']").css("display","none");
				$("#inputType").find("a[data='1']").css("display","block");
				$("#inputType").find("a[data='5']").css("display","none");
			}
		}
		
	}
	
}

///属性面板的点击事件[公共-是否可以？]
function selItems(selObj)
{
	$(attrsels).attr('data_id',$(selObj).attr('data'));
	$(attrsels).attr('par_data',$(selObj).attr('par_data'));			//sufan 新增

	var name=$(selObj).attr('name');
	if(name==undefined){
		$(attrsels).html($(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('data')) //hxy 20201201  新增
	}else{
		$(attrsels).html(name+"的"+$(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('par_data'));	//hxy 20201201 st 新增
		$(attrsels).parent().parent().attr('data_name',$(selObj).attr('data'));	//ed
	}
	AllUlPanel();
}

///显示下拉框
function showCombox(attr){
	AllUlPanel()
	$("#combox").css("display","block");
	$("#combox").css("left",$(attr).offset().left);
	$("#combox").css("top",$(attr).offset().top+$(attr).height());
	attrsels = attr;
}

///下拉框选择
function chooseCombox(Text){
	$("#combox").css("display","none");
}

///删除动作
function deleteAction(action){
	$(action).parent().remove();
}

///添加动作then/else
function addeAction(action)
{
	var actionId = action==1?'then':'else';
	var htmlStyle= action==1?'':' style="color:red"'
	var html = ""
	html = html +"<div class='rule-action' id='0' data_type=''>"
	html = html +"<span class='icon icon-cancel' onclick='deleteAction(this)' title='删除当前节点'>&nbsp;</span>"
	html = html +"<span>"
	html = html +"	<span class='line-green'"+htmlStyle+">变量赋值:</span>"
	html = html +"	<span class='blank'>.</span>"
	html = html +"	<span class='line-darkcyan-zero' par_data='' data_id='' onclick='chooseVar(this)'>请选择变量1</span>"
	html = html +"	<span style='color: red;'>=</span>"
	html = html +"	<span class='blank' onclick='chooseType(this,1)'>.</span>"
	html = html +"	<span></span>"
	html = html +"</span>"
	html = html +"</div>";
	$("#"+actionId).append(html);
	AllUlPanel();
}

//单位面板浮现
function chooseUnit(Unit){
	attrsels = Unit
	AllUlPanel();
	var dataId = serverCall("web.DHCCKBCommon","GetUnitData"); //hxy 2020-12-02 st
	var html = serverCall("web.DHCCKBRuleEditor","QueryDictonHtml",{"dicTionId":dataId,"q":""});
	$("#unit").html("")
	$("#unit").append(html);//ed
	$("#unit").css("display","block");
	$("#unit").css("left",$(Unit).offset().left);
	$("#unit").css("top",$(Unit).offset().top+$(Unit).height());
	$(Unit).attr("id","UnitActive");
	inputHide($("#UnitActive").prev()); //hxy 11-30 add(选择单位时，隐藏input) st 原来的UnitActive方法不被调用了
 	$(Unit).attr("id","");//ed
}

//规则面板浮现-(规则无,暂不处理)
function chooseRule(Rule){
	AllUlPanel();
	$("#rule").css("display","block");
	$("#rule").css("left",$(Rule).offset().left);
	$("#rule").css("top",$(Rule).offset().top+$(Rule).height());
	$(Rule).attr("id","RuleActive");
}

//比较操作符面板-选择触发
function OperaActive(Text,Value){ //20201126 add Value 
	if(Text=="Between"){
		$("#OperaActive").text("在");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之间</strong></span>")
	}else if(Text=="在集合"){
		$("#OperaActive").text("在集合");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之中</strong></span> ")
	}else{
		$("#OperaActive").text(Text);
		$("#OperaActive").next().next().next().html(""); //置空
	}
	$("#OperaActive").attr("data",Value); //20201126 add
	$("#OperaActive").next().next().html(""); //置空 11-16
	if(Text=="Between"){//2020-12-11 选择between时,直接默认选好上下线； st
		chooseType($("#OperaActive").next());
	}//ed
	$("#OperaActive").attr("id","");
	$("#operation").css("display","none");
}

//输入值类型面板-选择触发
function TypeActive(Text,Flag){
	var TextHtml="";
	if(Text=="I1"){//输入值
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
 		TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' value='' style='display: none;'>"
		$("#TypeActive").parent().parent().attr("data_type","Input");//20201130
	}
	if(Text=="I2"){//输入值(带单位)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputUom");//20201130
	}
	if(Text=="I3"){//输入值(上下线)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>" //viewInput2
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputLimit");//20201130
	}
	if(Text=="I4"){//选择变量
	}
	if(Text=="I5"){//选择数据集
		if(Flag==1){ //2021-03-04 sr
			TextHtml="<span onclick='chooseDataset(this,1)' data_id='1' class='line-blue'>请选择数据集</span>"
		}else{ //ed
		TextHtml="<span onclick='chooseDataset(this)' data_id='1' class='line-blue'>请选择数据集</span>"
		}
		$("#TypeActive").parent().parent().attr("data_type","Constant");//20201130
	}
	if(Text=="I6"){//选择规则
		TextHtml=	"<span class='line-purple' onclick='chooseRule(this)'>请选择规则</span>"
	}
	if($("#TypeActive").prev().prev().text()=="请选择变量1"){
		$.messager.alert("提示:","请先选择变量！");
	}
	$("#TypeActive").next().html(TextHtml); //append
	$("#TypeActive").attr("id","");
	$("#inputType").css("display","none");
}

///请选择数据集事件
function chooseDataset(dataset,Flag) //Flag=1是动作那么、否则；和变量、条件分开后的结构不一样了
{
	attrsels = dataset
	AllUlPanel();
	//var dataId = $(dataset).parent().prev().prev().prev().attr("data_id");
	var dataId = $(dataset).parent().parent().parent().prev().find(".line-darkcyan").attr("data_id");
	if(Flag==1){
		var dataId = $(dataset).parent().prev().prev().prev().attr("data_id");
	}
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttr",{"attrId":dataId});
	$("#dataset").html("");
	$("#dataset").append(html);
	$("#dataset").css("display","block");
	$("#dataset").css("left",$(dataset).offset().left);
	$("#dataset").css("top",$(dataset).offset().top+$(dataset).height());
}

//请输入值点击事件
function viewInput(Input){
	$(Input).next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="请输入值"){text="";}
	if($(Input).parent().find("input").length==2){
		$(Input).next().next().css("display","inline");
		text=text.replace("(","").replace(")","");
		$(Input).next().val(text.split("-")[0]);
		$(Input).next().next().val(text.split("-")[1]);
	}else{
		//$(Input).next().css("display","inline");
		//$(Input).css("display","none");
		//var text=$(Input).text();
	 	//if(text=="请输入值"){text="";}
	 	$(Input).next().val(text);
	}
	return;
}

//请输入值点击事件-上下线
function viewInput2(Input){
	$(Input).next().css("display","inline");
	$(Input).next().next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="请输入值"){text="";}
	text=text.replace("(","").replace(")","");
	$(Input).next().val(text.split("-")[0]);
	$(Input).next().next().val(text.split("-")[1]);
}

//输入值的input隐藏，变text
function inputHide(Hide){
	//alert($(Hide).parent().find("input").length)
	if($(Hide).parent().find("input").length==2){
		inputHide2(Hide);
	}else{
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	if($(Hide).val()==""){ //2020-12-17 st
		$(Hide).prev().text("请输入值");
	}else{
	$(Hide).prev().text($(Hide).val());
	}//ed
	}
}

//输入值的input1隐藏，变text
function inputHide1(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	$(Hide).prev().text("("+$(Hide).val()+"-)");
}

//输入值的input2隐藏，变text
function inputHide2(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().prev().css("display","inline");
	var text=$(Hide).prev().prev().text().split("-")[0]+"-"+$(Hide).val()+")";
	$(Hide).prev().prev().text(text);
}

//输入值的input1隐藏，变text,通过input2的单击
function inputHide1B2(Hide){
	$(Hide).prev().css("display","none");
	$(Hide).prev().prev().css("display","inline");
	$(Hide).prev().prev().text("("+$(Hide).prev().val()+"-)");
}

///隐藏所有ul弹窗面板
function AllUlPanel(){
	$("#operation").css("display","none");
	$("#inputType").css("display","none");
	$("#unit").css("display","none");
	$("#drugattr").css("display","none");
	$("#dataset").css("display","none");
	$("#combox").css("display","none"); //2021-02-02
	$("#TypeActive").attr("id",""); //2020-12-11 新增一个条件/动作，只选择到比较值符号，数据值类型只弹窗，未选择，再新增第二个条件/动作，选择数据集时到了第一个条件上；
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })