var _json
var _json=[{"ruleId":61466,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"����","variableLabel":"������Ⱥ","variableName":"91","ruleData":"1204559"},"type":"variable","ruleData":"1204559"},"value":{"constantCategory":"22136","constantName":"22136","constantLabel":"���������������","valueType":"Constant","ruleData":"1204559"},"op":"Equals","ruleData":"1204559"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"����","variableLabel":"����","variableName":"85","ruleData":"1204560"},"type":"variable","ruleData":"1204560"},"value":{"content":"1","contentUom":"4501","contentUomDesc":"��","contentLimit":"7","valueType":"InputLimit","ruleData":"1204560"},"op":"Between","ruleData":"1204560"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"��ҩ","variableLabel":"���θ�ҩ����","variableName":"49","ruleData":"1204561"},"type":"variable","ruleData":"1204561"},"value":{"content":"3","contentUom":"8947","contentUomDesc":"��λ/kg","contentLimit":"","valueType":"InputUom","ruleData":"1204561"},"op":"LessThenEquals","ruleData":"1204561"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"��ҩ","variableLabel":"��ҩƵ��","variableName":"45","ruleData":"1204562"},"type":"variable","ruleData":"1204562"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1204562"},"op":"Equals","ruleData":"1204562"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"��ҩ","variableLabel":"��ҩ;��","variableName":"46","ruleData":"1204563"},"type":"variable","ruleData":"1204563"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"����ע��","valueType":"Constant","ruleData":"1204563"},"op":"Equals","ruleData":"1204563"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"��ҩ","variableLabel":"��ҩ;��","variableName":"46","ruleData":"1204564"},"type":"variable","ruleData":"1204564"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"������ע","valueType":"Constant","ruleData":"1204564"},"op":"Equals","ruleData":"1204564"}],"ruleData":"893150"}],"ruleData":893149}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"ͨ�����","variableCategory":"ҩƷ���","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"ͨ��","ruleData":"1204565"},"ruleData":"1204565"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"������","variableCategory":"ҩƷ���","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"��ʾ","ruleData":"1204566"},"ruleData":"1204566"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"��ʾ��Ϣ","variableCategory":"ҩƷ���","variableCategoryId":16,"value":{"valueType":"Input","content":"�������ÿ�ΰ�����3��λ/kg��������һ��ÿ12Сʱ1�Σ�2~4����ÿ8Сʱ1�Σ��Ժ�ÿ6Сʱ1�Ρ�"},"ruleData":"1204567"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"ͨ�����","variableCategory":"ҩƷ���","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"��ͨ��","ruleData":"1204568"},"ruleData":"1204568"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"������","variableCategory":"ҩƷ���","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"��ʾ","ruleData":"1204569"},"ruleData":"1204569"}]}}]}]
var selectBox = [{"value":"and","text":'����'}, {"value":"or","text":'����'}, {"value":"union","text":'����'}, {"value":"additem","text":'�������'}, {"value":"addunionitem","text":'�����������'}, {"value":"del","text":'ɾ��'}];
var attrsels = "";   //��̬���ѡ�����
function initPageDefault()
{
	/*alert($("#test").offset().top)
	alert($("#test").offset().left)
	alert($("#test").width())
	alert($("#test").height())*/
	
	//Part2st ��ô
	var rhs=_json[0].rules[0].rhs.actions;
	var htmlTwo="<div id='then' style='padding: 5px;' class='ui-sortable'>"
	for (i=0; i<rhs.length; i++) {
		 htmlTwo=htmlTwo+"<div class='rule-action' id='"+rhs[i].ruleData+"' data_type='"+rhs[i].value.valueType+"'>" //2020-12-03 data_type
		 htmlTwo=htmlTwo+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		 htmlTwo=htmlTwo+"<span>"//2020-12-03 add
		 htmlTwo=htmlTwo+" <span class='line-green'>������ֵ:</span>"
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+" <span class='line-darkcyan-zero' par_data='"+rhs[i].variableCategoryId+"' data_id='"+rhs[i].variableName+"'>"+rhs[i].variableCategory+"��"+rhs[i].variableLabel+"</span>"
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
	
	//Part3st ����
	var other=_json[0].rules[0].other.actions;
	var htmlThr="<div id='else' style='padding: 5px' class='ui-sortable'>"	    
	for (i=0; i<other.length; i++) {
		htmlThr=htmlThr+"<div class='rule-action' id='"+other[i].ruleData+"' data_type='"+other[i].value.valueType+"'>"
		htmlThr=htmlThr+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		htmlThr=htmlThr+"<span>"//2020-12-03 add
		htmlThr=htmlThr+"  <span class='line-green' style='color:red'>������ֵ:</span>"
		htmlThr=htmlThr+"  <span class='blank'>.</span>"
		htmlThr=htmlThr+"  <span class='line-darkcyan-zero' par_data='"+other[i].variableCategoryId+"' data_id='"+other[i].variableName+"'>"+other[i].variableCategory+"��"+other[i].variableLabel+"</span>"
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

///ѡ��Ƚϲ�������帡��
function chooseOpera(Opera){
	AllUlPanel();
	$("#operation").css("display","block");
	$("#operation").css("left",$(Opera).offset().left);
	$("#operation").css("top",$(Opera).offset().top+$(Opera).height());
	$(Opera).attr("id","OperaActive");
}

//����ֵ������帡��
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
	if(value==1){//2020-12-03 then/elseֻѡ����ֵ�����ݼ�,ԭ��ԭͼ�׵����뵥λ�������߲�����,�ҵ�ǰ������Ҫ
		if(html!=""){
			TypeActive('I5',1); //2021-03-04 �ڶ�������1�����Ƕ�����ô��������ݼ�ѡ����ṹ������������ͬ
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

///�������ĵ���¼�[����-�Ƿ���ԣ�]
function selItems(selObj)
{
	$(attrsels).attr('data_id',$(selObj).attr('data'));
	$(attrsels).attr('par_data',$(selObj).attr('par_data'));			//sufan ����

	var name=$(selObj).attr('name');
	if(name==undefined){
		$(attrsels).html($(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('data')) //hxy 20201201  ����
	}else{
		$(attrsels).html(name+"��"+$(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('par_data'));	//hxy 20201201 st ����
		$(attrsels).parent().parent().attr('data_name',$(selObj).attr('data'));	//ed
	}
	AllUlPanel();
}

///��ʾ������
function showCombox(attr){
	AllUlPanel()
	$("#combox").css("display","block");
	$("#combox").css("left",$(attr).offset().left);
	$("#combox").css("top",$(attr).offset().top+$(attr).height());
	attrsels = attr;
}

///������ѡ��
function chooseCombox(Text){
	$("#combox").css("display","none");
}

///ɾ������
function deleteAction(action){
	$(action).parent().remove();
}

///��Ӷ���then/else
function addeAction(action)
{
	var actionId = action==1?'then':'else';
	var htmlStyle= action==1?'':' style="color:red"'
	var html = ""
	html = html +"<div class='rule-action' id='0' data_type=''>"
	html = html +"<span class='icon icon-cancel' onclick='deleteAction(this)' title='ɾ����ǰ�ڵ�'>&nbsp;</span>"
	html = html +"<span>"
	html = html +"	<span class='line-green'"+htmlStyle+">������ֵ:</span>"
	html = html +"	<span class='blank'>.</span>"
	html = html +"	<span class='line-darkcyan-zero' par_data='' data_id='' onclick='chooseVar(this)'>��ѡ�����1</span>"
	html = html +"	<span style='color: red;'>=</span>"
	html = html +"	<span class='blank' onclick='chooseType(this,1)'>.</span>"
	html = html +"	<span></span>"
	html = html +"</span>"
	html = html +"</div>";
	$("#"+actionId).append(html);
	AllUlPanel();
}

//��λ��帡��
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
	inputHide($("#UnitActive").prev()); //hxy 11-30 add(ѡ��λʱ������input) st ԭ����UnitActive��������������
 	$(Unit).attr("id","");//ed
}

//������帡��-(������,�ݲ�����)
function chooseRule(Rule){
	AllUlPanel();
	$("#rule").css("display","block");
	$("#rule").css("left",$(Rule).offset().left);
	$("#rule").css("top",$(Rule).offset().top+$(Rule).height());
	$(Rule).attr("id","RuleActive");
}

//�Ƚϲ��������-ѡ�񴥷�
function OperaActive(Text,Value){ //20201126 add Value 
	if(Text=="Between"){
		$("#OperaActive").text("��");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>֮��</strong></span>")
	}else if(Text=="�ڼ���"){
		$("#OperaActive").text("�ڼ���");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>֮��</strong></span> ")
	}else{
		$("#OperaActive").text(Text);
		$("#OperaActive").next().next().next().html(""); //�ÿ�
	}
	$("#OperaActive").attr("data",Value); //20201126 add
	$("#OperaActive").next().next().html(""); //�ÿ� 11-16
	if(Text=="Between"){//2020-12-11 ѡ��betweenʱ,ֱ��Ĭ��ѡ�������ߣ� st
		chooseType($("#OperaActive").next());
	}//ed
	$("#OperaActive").attr("id","");
	$("#operation").css("display","none");
}

//����ֵ�������-ѡ�񴥷�
function TypeActive(Text,Flag){
	var TextHtml="";
	if(Text=="I1"){//����ֵ
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>������ֵ</span>"
 		TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' value='' style='display: none;'>"
		$("#TypeActive").parent().parent().attr("data_type","Input");//20201130
	}
	if(Text=="I2"){//����ֵ(����λ)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>������ֵ</span>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>��ѡ��λ</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputUom");//20201130
	}
	if(Text=="I3"){//����ֵ(������)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>������ֵ</span>" //viewInput2
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>��ѡ��λ</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputLimit");//20201130
	}
	if(Text=="I4"){//ѡ�����
	}
	if(Text=="I5"){//ѡ�����ݼ�
		if(Flag==1){ //2021-03-04 sr
			TextHtml="<span onclick='chooseDataset(this,1)' data_id='1' class='line-blue'>��ѡ�����ݼ�</span>"
		}else{ //ed
		TextHtml="<span onclick='chooseDataset(this)' data_id='1' class='line-blue'>��ѡ�����ݼ�</span>"
		}
		$("#TypeActive").parent().parent().attr("data_type","Constant");//20201130
	}
	if(Text=="I6"){//ѡ�����
		TextHtml=	"<span class='line-purple' onclick='chooseRule(this)'>��ѡ�����</span>"
	}
	if($("#TypeActive").prev().prev().text()=="��ѡ�����1"){
		$.messager.alert("��ʾ:","����ѡ�������");
	}
	$("#TypeActive").next().html(TextHtml); //append
	$("#TypeActive").attr("id","");
	$("#inputType").css("display","none");
}

///��ѡ�����ݼ��¼�
function chooseDataset(dataset,Flag) //Flag=1�Ƕ�����ô�����򣻺ͱ����������ֿ���Ľṹ��һ����
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

//������ֵ����¼�
function viewInput(Input){
	$(Input).next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="������ֵ"){text="";}
	if($(Input).parent().find("input").length==2){
		$(Input).next().next().css("display","inline");
		text=text.replace("(","").replace(")","");
		$(Input).next().val(text.split("-")[0]);
		$(Input).next().next().val(text.split("-")[1]);
	}else{
		//$(Input).next().css("display","inline");
		//$(Input).css("display","none");
		//var text=$(Input).text();
	 	//if(text=="������ֵ"){text="";}
	 	$(Input).next().val(text);
	}
	return;
}

//������ֵ����¼�-������
function viewInput2(Input){
	$(Input).next().css("display","inline");
	$(Input).next().next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="������ֵ"){text="";}
	text=text.replace("(","").replace(")","");
	$(Input).next().val(text.split("-")[0]);
	$(Input).next().next().val(text.split("-")[1]);
}

//����ֵ��input���أ���text
function inputHide(Hide){
	//alert($(Hide).parent().find("input").length)
	if($(Hide).parent().find("input").length==2){
		inputHide2(Hide);
	}else{
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	if($(Hide).val()==""){ //2020-12-17 st
		$(Hide).prev().text("������ֵ");
	}else{
	$(Hide).prev().text($(Hide).val());
	}//ed
	}
}

//����ֵ��input1���أ���text
function inputHide1(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	$(Hide).prev().text("("+$(Hide).val()+"-)");
}

//����ֵ��input2���أ���text
function inputHide2(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().prev().css("display","inline");
	var text=$(Hide).prev().prev().text().split("-")[0]+"-"+$(Hide).val()+")";
	$(Hide).prev().prev().text(text);
}

//����ֵ��input1���أ���text,ͨ��input2�ĵ���
function inputHide1B2(Hide){
	$(Hide).prev().css("display","none");
	$(Hide).prev().prev().css("display","inline");
	$(Hide).prev().prev().text("("+$(Hide).prev().val()+"-)");
}

///��������ul�������
function AllUlPanel(){
	$("#operation").css("display","none");
	$("#inputType").css("display","none");
	$("#unit").css("display","none");
	$("#drugattr").css("display","none");
	$("#dataset").css("display","none");
	$("#combox").css("display","none"); //2021-02-02
	$("#TypeActive").attr("id",""); //2020-12-11 ����һ������/������ֻѡ�񵽱Ƚ�ֵ���ţ�����ֵ����ֻ������δѡ���������ڶ�������/������ѡ�����ݼ�ʱ���˵�һ�������ϣ�
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })