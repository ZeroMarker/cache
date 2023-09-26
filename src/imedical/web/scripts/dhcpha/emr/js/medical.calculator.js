var formula;
$(function() {
	$('body').layout('add',{
		id:'calculatorpanel',
		region: 'east',
		width: 800,
		title: '������',
		collapsed: true
	});
	//$('#calculatorpanel').append('<a id="ruler"></a>');
});
//ҳ���е�"������Ŀ"����¼�
function itemclick(obj){
	$('#calculatorpanel').empty();
	$('#calculatorpanel').panel('setTitle',obj.innerText);
	creatItem(obj);
	$('body').layout('expand','east');
}

//���ٲ��ҵ���¼�
function FindButtonClick(str){ 
	if(str == ""){  
		alert("������Ҫ���ҵĹؼ���!"); 
		return false;  
	}
	var ItemList = $('.item')
	var Itemid="";
	for(var i=0; i<ItemList.length; i++){
		if((ItemList[i].innerText.indexOf(str)>=0)||(ItemList[i].id.indexOf(str)>=0)) Itemid = ItemList[i].id;
	}
	if(Itemid == "") return false;
	var offset = $('#'+Itemid).offset();
	if(offset == undefined){
		return false;
	}
	$('#itemlist').animate({scrollTop:$('#itemlist').scrollTop()-$('#letterlable')[0].offsetHeight+offset.top-10});
}

function AddButtonClick(){
	var AddFormula= '<iframe id="frameAddFormula" src="emr.medical.calculator.create.csp" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle"></iframe>'	
    $('#calculatorpanel').append(AddFormula);
	$('body').layout('expand','east');
}

//��������ҳ��
function creatItem(obj){
	$.ajax({
		url:'../EMRservice.Ajax.MedicalCalculate.cls',
		data:{
			"Action":"getitem",
			"Name":obj.id
		},
		success:function(data){
			formula = eval('(' + data + ')');
			var VarName = formula.Variable.split('^');
			var VarDesc = formula.VarDesc.split('^');
			var VarType = formula.VarType.split('^');
			var VarUnit = formula.VarUnit.split('^');
			var VarParam = formula.VarParam.split('^');
			var Result = formula.Result.split('^');
			var ResDesc = formula.ResDesc.split('^');
			var ResUnit = formula.ResUnit.split('^');
			var content = $('<div></div>');
			var html = '<table style="margin:75px auto;font-size:12px;" align="center">';
			html = html + '<tbody><tr>';
			html = html + '<th style="color:red;">����:</th>';//�̶�
			for(var i=0; i<VarName.length; i++){
				html = html + '<tr><td></td><td style="text-align:right;color:#365BBD;">'+VarDesc[i]+':</td>';
				switch(VarType[i]){
					case 'N':
						//���������ֵ��
						html = html + '<td><input id="Input'+VarName[i]+'" type="text"></input></td>';
						break;
					case 'S':
						//�������ѡ����
						html = html + '<td><select id="Input'+VarName[i]+'" style="width:152px;">';
						var Options = VarParam[i].split('!');
						for(var j=0; j<Options.length; j++){
							Option = Options[j].split('#');
							html = html + '<option value ="'+Option[0]+'">'+Option[1]+'</option>';
						}
						html = html + '</select></td>';
						break;
					case 'C':
						//���������ѡ��
						var CheckValue = VarParam[i];
						html = html + '<td><input id="Input'+VarName[i]+'" type="checkbox" value=0 onclick="checkchange(this)"></input></td>';
				}
				if("" != VarUnit[i]) html = html +'<td style="color:#365BBD;">('+ VarUnit[i] +')</td>';
				html = html + '</tr>';
			}
			if (formula.Precision==1) html = html + '<tr><td></td><td style="text-align:right;color:#365BBD;">С��λ:<td><select id="Decimaldigit" style="width:152px;"><option value ="default">Ĭ�Ͼ���</option><option value =0>0</option><option value =1>1</option><option value =2 selected="true">2</option><option value =3>3</option><option value =4>4</option></select></td></tr>';//�̶�
			
			html = html + '<tr><td></td><td></td><td></td><td><button id="calculate" type="button" onClick="btnclick()">�� ��</button></td></tr>';//�̶�
			html = html + '<th style="color:red;">���:</th>';//�̶�//�̶�
			//������
			for(var i=0; i<Result.length; i++){
				html = html + '<tr><td></td><td style="text-align:right;color:#365BBD;">'+ResDesc[i]+':</td><td><input id="Result'+Result[i]+'" type="text" style="background:#D1EEEE;"></input></td>';
				if("" != ResUnit[i]) html = html +'<td style="color:#365BBD;">('+ ResUnit[i] +')</td>';
				html = html + '</tr>';
			}
			html = html + '</tbody></table>';
			$(content).append(html);
			$('#calculatorpanel').append(content);
		}
	})
}

function checkchange(obj){
	obj.value = 1-obj.value;
}

function btnclick(){
	//��ȡҳ���е�����ֵ
	var VarName = formula.Variable.split('^');
	var Result = formula.Result.split('^');
	var Formula = formula.Formula.split('^');
	var CalResult = new Array(Result.length);
	var str = "";
	for(var i=0; i<VarName.length; i++){
		str = str + 'var '+VarName[i]+'=$("#Input'+VarName[i]+'").val();';
	}
	//�洢�ں�̨�ļ��㹫ʽ
	for(var i=0; i<CalResult.length; i++){
		str = str+'CalResult['+i+'] = '+Formula[i]+';';
	}
	eval(str);	
	//����ҳ��Ҫ����ʾ��С����λ��,�Խ�����޸�,Ĭ����ʾ��λС��
	for(var i=0; i<CalResult.length; i++){
		if(1 == formula.Precision){
			var Decimaldigit = $('#Decimaldigit').val();
			var ResultShow = "";
			if ("default" == Decimaldigit)
			{
				ResultShow = CalResult[i];
			}
			else
			{
				ResultShow = CalResult[i].toFixed(Decimaldigit);
			}
		}
		else
		{
			ResultShow = CalResult[i];
		}
		var Resultstr = '#Result'+Result[i];
		$(Resultstr).val(ResultShow);
	}
}

function visualLength(str){
	var ruler = $("#ruler");
	ruler.text(str);
	var length = ruler[0].offsetWidth;
	ruler.text("");
	return length;
}