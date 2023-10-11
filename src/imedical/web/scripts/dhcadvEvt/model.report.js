//model.report.js
//�����¼�ͳ��
//zhouxin
//2019-05-30
var Code="",Quoteflag="",ModelID="",pid=0;
var curCondRow=1;
var LgParam=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
var condArray= [{ "val": "and", "text": $g("����") },{ "val": "or", "text": $g("����") }]; //�߼���ϵ
var stateBoxArray= [{ "val": "=", "text": $g("����") },{ "val": ">", "text": $g("����") },{ "val": ">=", "text": $g("���ڵ���") },{ "val": "<=", "text": $g("С�ڵ���") },{ "val": "<", "text": $g("С��") }]; //����
$(function(){ 
	InitControl();
	InitCombobox();			
	initValue();
	initBTN();
	initPagination();
	initInput();
	addCondition();
	
});
/// ��ʼ��
function InitControl()
{
	Code=getParam("Code");
	Quoteflag=getParam("Quoteflag");  // ���ý��봫ֵ �գ� ��ҳ���봫ֵ 1
	if(Quoteflag=="1"){
		$("#statempTd").show(); // ��ҳ���� ��ʾ����ͳ��������
		$("#gologin").show();
		$("#tableform").css({width:'90%',margin:'10px 100px 0 100px'})
	}else{
		$("#nourthlayout").hide();
		$("#tableform").css({width:'97%',margin:'10px 10px 0 10px'});
		$("#centerlayout").css({height:'auto'});
		$(".layout-panel").css({'position':'static'});
	}
	
	// ��ȡģ��id �� pid
	if(Code!=""){
		runClassMethod("web.DHCADVModel","GetModelInfo",{'code':Code},
		function(data){
			ModelID=data.split("$$")[2];
			pid=data.split("$$")[1];
			$("#tbhead").html(data);
		},"text",false);
	}
	
}
///��ʼ������������
function InitCombobox()
{
	// ͳ������
	$('#statemp').combobox({
		url:$URL+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryStaTemp&HospDr="+LgHospID,
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onSelect:function(option){
		// ��ȡģ��id �� pid
		if(option.code!=""){
			runClassMethod("web.DHCADVModel","GetModelInfo",{'code':option.code},
			function(data){
				ModelID=data.split("$$")[2];
				pid=data.split("$$")[1];
				$("#tbhead").html(data);
				$("#tableData").html("");
			},"text",false);
		}

		}
	})
	//�߼���ϵ
	$('#condCombox').combobox({
		panelHeight:"auto", 
		data:condArray
	});
}

function initInput(){
	$(".lookup-text").on("input propertychange",function(event){
       if($(this).val()==""){
	      $(this).attr("data-id","");
	   }
	});
}

function initValue(){
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		$('#querySt').datebox('setValue',tmp[0]);
		$('#queryEd').datebox('setValue',tmp[1]);
	},'',false)
}

function initBTN(){
	$("#queryBTN").on('click',function(){query(1);});
	$("#exportBTN").on('click',function(){exportData();});
	$("#addCondBTN").on('click',function(){addCondition();});
	$("#printBTN").on('click',function(){printData();});
}

function query(page){
	if(ModelID==""){
		$.messager.alert('��ʾ','��ѡ��ͳ������');
	}
	runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			page:page,
			rows:15,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			parStr:getParStr(),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			initHead(ret);
			var html="";
			var titleStrArr=ret.titleStr.split("^");
			var titleDicArr=ret.titleDicStr.split("^");
			var titleTypeArr=ret.titleTypeStr.split("^");
			var titleHiddenArr=ret.titleHidden.split("^");
			//console.log(ret.titleDicStr)
			$.each(ret.rows,function(index,itm){
				html+="<tr>";
				var trArr=itm.value.split("^")
				for(var i=0;i<trArr.length;i++){
					var hidden=titleHiddenArr[i]
					hidden=(hidden=="y")?"none":"";
					var yValue=(titleTypeArr[i]=="dateRange")?titleStrArr[i-1]:trArr[i];
					console.error(titleDicArr[i]);
					if((ret.subModel>0)&&(trArr[0].indexOf("(�ٷֱ�%)")<0)){
						html+="<td style=display:";
						html+=hidden;
						html+="><a  data-y='"+titleDicArr[i]+"' data-y-type='"+titleTypeArr[i]+"' data-y-value='"+yValue+"' data-x='"+titleDicArr[0]+"' data-x-value='"+trArr[0]+"' data-x-type='"+titleTypeArr[0]+"' data-submodel="+ret.subModel+" onClick='openSubModel(this)' style='cursor: pointer'>"+trArr[i]+"</a></td>";
					}else{
						html+="<td style=display:";
						html+=hidden;
						html+=">"+trArr[i]+"</td>";	
					}
					
				}
				html+="</tr>";
			})
			$("#tableData").html(html);
			var totalPage=Math.ceil(ret.total/15);
			$("#pagination").pagination("setPage", page, totalPage);
			initChart(ret);
			initPie(ret);
			initLine(ret);
		},'json'
	);	
}
function initHead(ret){
	if(ret.titleHtml!=""){
		$(".dhc-table").find("tr").remove();
		var colspan=ret.titleStr.split("^").length+1;
		var html="<tr><th colspan="+colspan+"><h2>"+ret.reportName+"</h2></th></tr>";
		html+="<tr>"+ret.titleHtml+"</tr>";
		$(".dhc-table").find("thead").append(html);		
	}

}
function openSubModel(obj){
	var st=$('#querySt').datebox('getValue');
	var ed=$('#queryEd').datebox('getValue');
	var modelId=$(obj).attr("data-submodel");
	var x=$(obj).attr("data-x");
	var xType=$(obj).attr("data-x-type");
	var xValue=$(obj).attr("data-x-value");
	var y=$(obj).attr("data-y");
	var yType=$(obj).attr("data-y-type");
	var yValue=$(obj).attr("data-y-value");
	
	var del=String.fromCharCode(1);
	var parStr="",condType=2;
	if(xType=="dateRange"){
		condType=1;
	}
	parStr+=condType+del+x+del+xValue+del+xType;
	parStr+="^1"+del+y+del+yValue+del+yType;
	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('����༭'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		width:screen.availWidth-200,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-200
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.model.report.sub.csp?modelId='+modelId+"&st="+st+"&ed="+ed+"&parStr="+escape(parStr)+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	//window.open("dhcadv.model.report.sub.csp?modelId="+modelId+"&st="+st+"&ed="+ed+"&parStr="+escape(parStr))	

}
function initPagination(){
		$("#pagination").pagination({
			currentPage: 0,
			totalPage: 0,
			isShow: true,
			homePageText: "��ҳ",
			endPageText: "βҳ",
			prevPageText: "��һҳ",
			nextPageText: "��һҳ",
			callback: function(current) {
				query(current);
			}
		});	
}

function exportData(){
		runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			exportExcel(ret.rows,filename);
		},'json');
}


function onKeyPress(e,obj){

	if(e.which)
        keyCode = e.which;
    else if(e.keyCode)
        keyCode = e.keyCode;
	if(keyCode == 13) {
		var key=$(obj).attr("data-key");
		var input=$(obj).val();
		openDiv(input,key)
	}
}

function showDic(obj){
	var key=$(obj).attr("data-key");
	var input=$(obj).prev().val();
	openDiv(input,key)
}
function openDiv(input,key){
	
	var keyArr=key.split("-");
	var type=(keyArr[1]%2 ==0) ?"tree":"datagrid";
	var dic=0;
	if(type=="tree"){
		var tmpKey=keyArr[0]+"-"+(keyArr[1]-1);
		dic=$("#"+tmpKey).attr("data-id");
	}
	
	input=encodeURIComponent(input);
	var url="dhcadv.model.report.pop.csp?input="+input+"&key="+key+"&type="+type+"&dic="+dic;
	var content = '<iframe src="' + url + '" width="90%" height="100%" frameborder="0" scrolling="yes"></iframe>';
    $('#dicDia').dialog({
        content: content,
        maximized: false,//Ĭ�����
        modal: true
	});
	$('#dicDia').dialog('open');
}
function closeDiv(){
	$('#dicDia').dialog('close');
}
/////////////////////////////////////�߼���ѯ����////////////////////////////////////////
// ������
function addCondition(){
	
	curCondRow=curCondRow+1;
	var html=""
	html+='<tr id="'+curCondRow+'Tr"><td><b style="padding-left:30px">'+$g("��ѯ����")+'</b>';
	html+=getLookUpHtml(curCondRow,1);
	html+=getSelectHtml(curCondRow,1);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+1+' style="width:120"/></span>';
	html+='</td><td style="padding-left:60px"><b style="padding-left:30px">'+$g("��ѯ����")+'</b>';
	html+=getLookUpHtml(curCondRow,2);
	html+=getSelectHtml(curCondRow,2);
	html+='<span style="padding-left:20px;"><input class="dhcc-input" id="QueCond"'+curCondRow+"-"+2+' style="width:120"/></span>';
	html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="addCondition()"><span  class="icon icon-add" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("������")+'</span></td>>';
	if(curCondRow>2){
		html+='</td><td style="padding-left:20px"><span style="cursor: pointer" onclick="removeCond('+curCondRow+')"><span  class="icon icon-remove" >&nbsp;&nbsp;&nbsp;&nbsp;</span>'+$g("ɾ����")+'</span></td></tr>';
	}
	$("#condTable").append(html);
	//����
	$("input[id^=stateBox"+curCondRow+"-]").combobox({
		panelHeight:"auto", 
		data:stateBoxArray
	});
	
}
// ɾ����
function removeCond(row){
	$("#"+row+"Tr").remove();
}
// �������
function getSelectHtml(row,column){
	var key=row+"-"+column;
	var html='<span style="padding-left:20px;">';
	html+='<input  id="stateBox'+key+'" style="width:80;" class="easyui-combobox" data-options="valueField:\'val\',textField:\'text\'"/>'
	html+='</span>'
	return html;
}
// ��ѯ���� ��������
function getLookUpHtml(row,column){
	var html="";
	var key=row+"-"+column
	html+='<span class="lookup" style="padding-left:20px;">'
	html+='		<input class="dhcc-input" class="textbox lookup-text validatebox-text"  style="width: 120px;" id="'+key+'" onkeypress="return onKeyPress(event,this)" data-key='+key+' type="text" >'
	html+='		<span class="lookup-arrow" style="height: 28px;" onclick="showDic(this)" data-key='+key+'></span>'
	html+='</span>'
	return html;
}

/***
 * ����������   ���������Щ������Щ������Щ������� ���������Щ������Щ������Щ������� ���������Щ������Щ������Щ������� ���������Щ������Щ�������
 * ��Esc��   �� F1�� F2�� F3�� F4�� �� F5�� F6�� F7�� F8�� �� F9��F10��F11��F12�� ��P/S��S L��P/B��  ����    ����    ����
 * ����������   ���������ة������ة������ة������� ���������ة������ة������ة������� ���������ة������ة������ة������� ���������ة������ة�������  ����    ����    ����
 * ���������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ������Щ��������������� ���������Щ������Щ������� ���������Щ������Щ������Щ�������
 * ��~ `��! 1��@ 2��# 3��$ 4��% 5��^ 6��& 7��* 8��( 9��) 0��_ -��+ =�� BacSp �� ��Ins��Hom��PUp�� ��N L�� / �� * �� - ��
 * ���������ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ����������� ���������੤�����੤������ ���������੤�����੤�����੤������
 * �� Tab �� Q �� W �� E �� R �� T �� Y �� U �� I �� O �� P ��{ [��} ]�� | \ �� ��Del��End��PDn�� �� 7 �� 8 �� 9 ��   ��
 * �������������ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ةЩ����ة����������� ���������ة������ة������� ���������੤�����੤������ + ��
 * �� Caps �� A �� S �� D �� F �� G �� H �� J �� K �� L ��: ;��" '�� Enter  ��               �� 4 �� 5 �� 6 ��   ��
 * ���������������ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة��Щ��ة�����������������     ����������     ���������੤�����੤�����੤������
 * �� Shift  �� Z �� X �� C �� V �� B �� N �� M ��< ,��> .��? /��  Shift   ��     �� �� ��     �� 1 �� 2 �� 3 ��   ��
 * �������������Щ����ة��Щ��ة����Щة������ة������ة������ة������ة������ة����Щة������੤�����ةЩ��������Щ��������� ���������੤�����੤������ ���������ة������੤������ E����
 * �� Ctrl��    ��Alt ��         Space         �� Alt��    ��    ��Ctrl�� �� �� �� �� �� �� �� ��   0   �� . ����������
 * �������������ة��������ة��������ة����������������������������������������������ة��������ة��������ة��������ة��������� ���������ة������ة������� �����������������ة������ة�������
 */
function getParStr(){
	var retArr=[];
	var cond=$("#condCombox").val();
	$("#condTable").find("td").each(function(index,obj){
		if($(obj).children().length<3){
			return true;
		}
		var column=$(obj).children().eq(1).find("input").attr("data-id")
		if(column==""){
			return true;	
		}
		var columnDic=$(obj).children().eq(3).find("input").attr("data-id")
		var columnValue=$(obj).children().eq(3).find("input").val()
		var op=$(obj).children().eq(2).val()
		if(columnValue==""){
			return true;
		}
		
		var columType="dic";
		if(columnDic==""){
			type=2;
			value=$.trim(columnValue);
		}else{
			type=1;
			value=columnValue;
			column=columnDic;
		}
		
		//�Ƚ�����_$c(1)_��_$c(1)_ֵ_$c(1)_columType_$c(1)_�߼���ϵ
		var par=type;
		par+=String.fromCharCode(1)+column;
		par+=String.fromCharCode(1)+value;
		par+=String.fromCharCode(1)+columType;
		par+=String.fromCharCode(1)+op;
		par+=String.fromCharCode(1)+cond;
		retArr.push(par);
	})
	return retArr.join("^")
}
///��ӡ
function printData()
{
	runClassMethod("web.DHCADVModel","listData",
		{
			model:ModelID,
			pid:pid,
			pageFlag:1,
			st:$('#querySt').datebox('getValue'),
			ed:$('#queryEd').datebox('getValue'),
			params:LgParam //hxy 2020-02-26
		},function(ret){
			var filename=(new Date()).Format("yyyy-MM-dd hh:mm:ss.S");
			printHtml(ret.rows)
		},'json'
	);
}

function toggleExecInfo(obj){
	
	if($(obj).hasClass("expanded")){
		$(obj).removeClass("expanded");
		$(obj).html($g("�߼���ѯ"));
		$("#condTable").hide();
		$("#dashline").hide();
		$("#condTd").hide();
		
	}else{
		$(obj).addClass("expanded");
		$(obj).html($g("����"));
		$("#condTable").show();
		$("#dashline").show();
		$("#condTd").show();
	}
}
///����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
