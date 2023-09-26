var formula;
$(function() {
	$('body').layout('add',{
		id:'calculatorpanel',
		region: 'east',
		width: 800,
		title: '计算器',
		collapsed: true
	});
	//$('#calculatorpanel').append('<a id="ruler"></a>');
});
//页面中的"计算项目"点击事件
function itemclick(obj){
	$('#calculatorpanel').empty();
	$('#calculatorpanel').panel('setTitle',obj.innerText);
	creatItem(obj);
	$('body').layout('expand','east');
}

//快速查找点击事件
function FindButtonClick(str){ 
	if(str == ""){  
		alert("请输入要查找的关键字!"); 
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

//创建计算页面
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
			html = html + '<th style="color:red;">输入:</th>';//固定
			for(var i=0; i<VarName.length; i++){
				html = html + '<tr><td></td><td style="text-align:right;color:#365BBD;">'+VarDesc[i]+':</td>';
				switch(VarType[i]){
					case 'N':
						//输入参数数值型
						html = html + '<td><input id="Input'+VarName[i]+'" type="text"></input></td>';
						break;
					case 'S':
						//输入参数选择型
						html = html + '<td><select id="Input'+VarName[i]+'" style="width:152px;">';
						var Options = VarParam[i].split('!');
						for(var j=0; j<Options.length; j++){
							Option = Options[j].split('#');
							html = html + '<option value ="'+Option[0]+'">'+Option[1]+'</option>';
						}
						html = html + '</select></td>';
						break;
					case 'C':
						//输入参数勾选型
						var CheckValue = VarParam[i];
						html = html + '<td><input id="Input'+VarName[i]+'" type="checkbox" value=0 onclick="checkchange(this)"></input></td>';
				}
				if("" != VarUnit[i]) html = html +'<td style="color:#365BBD;">('+ VarUnit[i] +')</td>';
				html = html + '</tr>';
			}
			if (formula.Precision==1) html = html + '<tr><td></td><td style="text-align:right;color:#365BBD;">小数位:<td><select id="Decimaldigit" style="width:152px;"><option value ="default">默认精度</option><option value =0>0</option><option value =1>1</option><option value =2 selected="true">2</option><option value =3>3</option><option value =4>4</option></select></td></tr>';//固定
			
			html = html + '<tr><td></td><td></td><td></td><td><button id="calculate" type="button" onClick="btnclick()">计 算</button></td></tr>';//固定
			html = html + '<th style="color:red;">输出:</th>';//固定//固定
			//输出结果
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
	//获取页面中的输入值
	var VarName = formula.Variable.split('^');
	var Result = formula.Result.split('^');
	var Formula = formula.Formula.split('^');
	var CalResult = new Array(Result.length);
	var str = "";
	for(var i=0; i<VarName.length; i++){
		str = str + 'var '+VarName[i]+'=$("#Input'+VarName[i]+'").val();';
	}
	//存储于后台的计算公式
	for(var i=0; i<CalResult.length; i++){
		str = str+'CalResult['+i+'] = '+Formula[i]+';';
	}
	eval(str);	
	//根据页面要求显示的小数点位数,对结果做修改,默认显示两位小数
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