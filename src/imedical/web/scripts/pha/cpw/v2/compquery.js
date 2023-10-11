/**
 * @ģ��:     ҩѧ�ۺϲ�ѯ
 * @��д����: 2019-11-04
 * @��д��:   pushuangcai
 */
var COLUMNS = [
	{field:"AdmDr", title:'AdmDr', width:90, hidden:true},
	{field:'Ward', title:$g('����'), width:150},
	{field:'PatNo', title:$g('�ǼǺ�'), width:100},
	{field:'PatName', title:$g('����'), width:80}
];
$(function(){
	InitDict();
	InitColumns();	
	InitPatList();
	queryItm();
})
/**
 * �������
 * @method InitDict
 */
var InitDict = function(){
	$('#ward').combobox({ 			//����
		mode:'remote',
		onShowPanel:function(){ 
			$('#ward').combobox('reload','dhcpha.clinical.action.csp?action=GetAllWardNewVersion&hospId=' + LgHospID)
		}
	});
	$("#Pharmacist").combobox({		//�û�
		panelHeight:"auto", 
		onShowPanel:function(){
			$('#Pharmacist').combobox('reload','dhcpha.clinical.action.csp?action=GetGroupUser&grpId=' + LgGroupID)
		}
	});
	$("#StDate").datebox("setValue", formatDate(-31));  
	$("#EdDate").datebox("setValue", formatDate(0));  
	$("#Find").bind("click", queryItm);
	$("#Clear").bind("click", Clear);
	   
	$("#PatNo").bind('keypress',function(event){       
		if(event.keyCode == "13"){
			var patno=$.trim($("#PatNo").val());
			if (patno!=""){
				while(patno.length<10){
					patno = "0" + patno;
				}
			}
			$(this).val(patno);
			queryItm();
		}
	 });
	 /*��checkbox����¼� */
	$("input[name=qItm]").bind("click", function(){
		var sliceInd = findIndex(COLUMNS, this.id);
		if(this.checked){
			if(sliceInd < 0){
				COLUMNS.push({field: this.id, title: this.value, width: 250, formatter: strFormatter})
			}
		}else{
			if(sliceInd > -1){
				COLUMNS.splice(sliceInd, 1);
			}	
		} 
		InitPatList();
	});
}
/**
 * ��ʼ���б�����ʾ����
 * @method InitColumns
 */
var InitColumns = function(){
	/*��ʼ��Ĭ����ʾ��*/
	$.each($("input[name=qItm]"), function(k, chkObj){
		if(chkObj.checked){
			var formatterFun;
			
			var sliceInd = findIndex(COLUMNS, this.id);
			if(sliceInd > -1){
				return true;	
			}
			if(chkObj.id=='AdrRep'){
				COLUMNS.push({field: chkObj.id, title: chkObj.value, width: 250, formatter: adrFormmatter})
			}else if(chkObj.id=="DrgCal"){
				COLUMNS.push({field: chkObj.id, title: chkObj.value, width: 250, formatter: medRecFormatter})
			}else{
				COLUMNS.push({field: chkObj.id, title: chkObj.value, width: 250, formatter: strFormatter})
			}
		}
	});
}
/**
 * �����б������������λ��
 * @method findIndex
 * @array ������
 * @item ����
 */
var findIndex = function(array, item){
	for(var i in array){
		if(array[i].field == item){
			return i;	
		}	
	}
	return -1;
}
/**
 * ��ʼ��������Ϣ�б�
 * @method InitPatList
 */
var InitPatList = function(){
	var gridOption = {
		fit: true,
		title: $g('�ٴ�ҩѧ�ۺϲ�ѯ'),
		singleSelect: true,
		columns: [COLUMNS],
		//nowrap: false,
		pagination: true,
		url: 'dhcapp.broker.csp'
	};
    $('#patCompList').datagrid(gridOption);
}
/**
 * ��ѯ����
 * @method getParam
 */
var queryItm = function(){
	var params = getParam();
	$('#patCompList').datagrid('load', {
		ClassName: "PHA.CPW.Comp.Query",
		MethodName: "QueryPatCpwRecord",
		params: params
	});
}
/**
 * ��ȡ����ֵ
 * @method getParam
 */
var getParam = function(){
	var stDate = $('#StDate').datebox('getValue'); 
	var enDate = $('#EdDate').datebox('getValue');
	var ward = $("#ward").combobox('getValue')||"";  
	var pharmacist = $("#Pharmacist").combobox('getValue')||""; 
	var patno = $("#PatNo").val()||"";	
	var chkItm = "";	 
	$.each($("input[name=qItm]"), function(k, chkObj){
		if(chkObj.checked){
			chkItm += "%"+chkObj.id;
		}
	})
	var params = stDate +"^"+ enDate +"^"+ ward +"^"+ pharmacist +"^"+ chkItm +"^"+ patno+"^"+LgHospID;	
	return params;
}
/**
 * ��ʽ����
 * @method strFormatter
 */
var strFormatter = function(value,row,index){
	if (!value){
		return value;
	}else{
		var valArr = value.split(";");
		var linkStr = "";
		var tmpVal = "";
		var pointor = "";
		var field = this.field;
		var type = "";
		switch (field) {
			case 'Phw' : type = "WR"; break;
			case 'Pha' : type = "MA"; break;
			case 'Phcp' : type = "CP"; break;
			case 'Phc' : type = "MON"; break;
			case 'MedEdu' : type = "ED"; break;
			default : ''
		}
		var tmpHtml;
		$.each(valArr, function(index, val){
			if(val==""){return true;}
			tmpVal = val.split("#")[0].replace(/\^/g," / ");
			pointor = val.split("#")[1]||"";
			tmpHtml = "<a class='easyui-linkbutton' onclick='showPatMonWin("+ row.AdmDr +",\""+ type +"\",\"" + pointor + "\");'>" 
				+ tmpVal + "<img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>"; 
			linkStr = linkStr == "" ? tmpHtml : linkStr +"<br>"+ tmpHtml;
		})
		return linkStr;
	}
}
/**
 * �鿴ҩѧ�����ϸ���棬�����ӵ���Ӧҵ����Ϣ
 * @method showPatMonWin
 * @EpisodeID ����id
 * @type ҵ�����ͣ���ȱʡ
 * @point ��Ӧҵ���id����ȱʡ
 */                              
function showPatMonWin(EpisodeID, type, point){ 
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		minimizable:false,					
		maximized:true						
	};
	new WindowUX($g('����ҩѧ�����Ϣ��ѯ'), 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID+'&bsType='+type+'&bsPoint='+point+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);  
}
/**
 * ��ʽ��������������
 * @method adrFormmatter
 */  
function adrFormmatter(value, rowData, rowIndex){
	if (!value){
		return value;
	}else{
		var valArr = value.split(";");
		var linkStr = "";
		var tmpVal = "";
		var recordStr = "";
		var field = this.field;
		var recordParaArr;
		var tmpHtml;
		$.each(valArr, function(index, val){
			if(val==""){return true;}
			tmpVal = val.split("#")[0].replace(/\^/g," / ");
			recordStr = val.split("#")[1]||"";
			recordParaArr = recordStr.split("$");
			var recordID=recordParaArr[0];         	//����д��¼ID
			var RepID=recordParaArr[1];             //����ID   
			var RepStaus=recordParaArr[2];          //��״̬
			if (RepStaus==$g("δ�ύ")){
				RepStaus=""; 						//����Ϊδ�ύ������Ϊ��
			}
			var RepTypeDr=recordParaArr[3];         //��������Dr
			var RepTypeCode=recordParaArr[4];    	//�������ʹ���
			var RepType=recordParaArr[5];    		//��������
			var RepUser=recordParaArr[6];   		//������
			var editFlag=-1;  						//�޸ı�־  1�����޸� -1�������޸�   
			var adrReceive=recordParaArr[7]; 		//����״̬dr
			tmpHtml = "<a onclick=\"showEditWin('"+ recordID +"','"+ RepStaus +"','"+ RepTypeDr +"','"
				+ RepTypeCode +"','"+ RepType +"','"+ editFlag +"','"+ RepID+"','"+ adrReceive +"')\">"
				+ tmpVal + "<img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>"
			linkStr = linkStr == "" ? tmpHtml : linkStr +"<br>"+ tmpHtml;
			/* if (linkStr==""){
				linkStr = tmpHtml;
			}else{
				linkStr += tmpHtml;
			} */
			
		})
		return linkStr;
	}
}
/**
 * ��ʾ����������ϸ��Ϣ
 * @method showEditWin
 */
function showEditWin(recordID,RepStaus,RepTypeDr,RepTypeCode,RepType,editFlag,RepID,adrReceive){
	if($('#win').is(":visible")){return;}  
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:$g('����༭'),
		collapsible:true,
		border:false,
		closed:"true",
		width:screen.availWidth-100,    
		height:screen.availHeight-100
	});
	var iframe='<iframe scrolling="yes" width=100% height=100% frameborder="0" src="dhcadv.layoutform.csp?recordId='
		+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='
		+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'&winflag='+1+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
/**
 * ��ʽ��ҩ������
 * @method medRecFormatter
 */
var medRecFormatter = function(value,row,index){
	if (!value){
		return value;
	}else{
		var valArr = value.split(";");
		var linkStr = "";
		var tmpVal = "";
		var tmpHtml;
		$.each(valArr, function(index, val){
			if(val==""){return true;}
			tmpVal = val.split("#")[0].replace(/\^/g," / ");
			tmpHtml = "<a onclick='showMedRecWin(\""+ row.AdmDr + "\");'>" + tmpVal 
				+ "<img src='../scripts/dhcadvEvt/images/adv_sel_8.png' border=0/></a>";
			linkStr = linkStr==""?tmpHtml: linkStr + "<br>" + tmpHtml;
		})
		return linkStr;
	}
}
/**
 * ��ʾҩ����Ϣ
 * @method showMedRecWin
 * @EpisodeID ����id
 */                              
function showMedRecWin(EpisodeID){ 
	var option = {
		collapsible:true,
		border:true,
		closed:"true",
		minimizable:false,					
		maximized:true						
	};
	new WindowUX($g('ҩ��'), 'newItmWin', '950', '550', option).Init();
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.drugbrows.csp?EpisodeID='+EpisodeID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	$("#newItmWin").html(iframe);  
}
function Clear(){
	   $("#StDate").datebox("setValue", formatDate(-31));  
	   $("#EdDate").datebox("setValue", formatDate(0));  
	   $("#ward").combobox("setValue","");
	   $("#Pharmacist").combobox("setValue","");
	   $('#PatNo').val("");
	   $("input[name=qItm]").prop("checked","checked");
	   InitColumns();
	   $('#patCompList').datagrid("options").queryParams = {};
	   InitPatList();
	   $('#patCompList').datagrid("loadData", {total:0,rows:[]});
	}