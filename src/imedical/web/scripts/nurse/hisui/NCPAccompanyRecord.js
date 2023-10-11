/**
* @author songchunli
* HISUI �¹��㻤��js
*/
var PageLogicObj={
	m_selAccompanyRecId:"", //��ѡ�޸��㻤��¼ID
	m_PatientListJson:[]
}
$(function(){ 
	InitNCPAccompanyRecDataGrid();
	InitEvent();
});
var comCardRtn = "";
function InitEvent(){
	/*$("#BSave").click(SaveNCPAccompanyRec);*/
	$("#SubRecSave").click(SaveNCPAccompanyRecSub);
	/*$("#BSavePrint").click(SavePrintNCPAccompanyRec);*/
	//$("#NCPARIdNo").blur(AccompanyCredNoBlur);
	//$("#NCPARIdNo").keydown(AccompanyNoOnKeyDown);
	/*$("#NCPARegNo").keydown(AccompanyNoOnKeyDown);
	$("#ReadCard").click(BtnReadCardHandler);
	$("#ReadPatInfo").click(ReadPatInfoHandler);*/
	$("#Active").click(NCPAccompanyRecSearchClick);
	$("#InActive").click(NCPAccompanyRecSearchClick);
	$("#BExport").click(ExportClick);
}
function setTableStyle(){
	var td_MaxWidth=0
	var _tds=$("#NCPAccompanyRecSubEditWin table tr td.r-label:first-child");
	for (var i=0;i<_tds.length;i++){
		var td_width=$(_tds[i]).width();
		if (td_width>td_MaxWidth) td_MaxWidth=td_width;
	}
	_tds.css("width",td_MaxWidth);
}

$(window).load(function() {
	$("#loading").hide();
	/*InitNCPAccompanyRecEditWin();
	InitNCPAccompanyRecEditWinData();*/
	InitNCPAccompanyRecSubEditWin();
})
function InitNCPAccompanyRecDataGrid(){
	var ToolBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				AddNCPAccompanyRec();				
			}
	},{
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			if (rows.length ==0) {
				$.messager.popover({msg:'δѡ���㻤��Ϣ,��ѡ��һ����Ҫ�޸ĵ��㻤��Ϣ��',type:'error'});
				return false;
			}else if(rows.length >1){
				$.messager.popover({msg:'ѡ���ж�����Ϣ����ֻѡ������һ��',type:'error'});
				return false;
			}
			if(rows[0].NCPARRowID=="")
			{
				$.messager.popover({msg:'��ѡ�����㻤��Ϣ�ļ�¼!',type:'error'});
				return false;
			}
			ShowNCPAccompanyRecWin(rows[0]);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			if (rows.length ==0) {
				$.messager.popover({msg:'δѡ����Ҫɾ�����㻤��Ϣ��¼��',type:'error'});
				return false;
			}
			var selRecordIDsArr=[];
			for (var i=0;i<rows.length;i++){
				if(rows[i].NCPARRowID == '') continue;
				selRecordIDsArr.push(rows[i].NCPARRowID);
			}
			if (selRecordIDsArr.length ==0){
				$.messager.popover({msg:'��ѡ�����㻤��Ϣ�ļ�¼����ɾ��!',type:'error'});
				return false;
			}
			$.messager.confirm('ȷ�϶Ի���', 'ɾ���󲻿ɻָ���ȷ������ɾ����?', function(r){
				if (r){
					$.m({
						ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
						MethodName:"DelCNCPAccompanyRec",
						RecordIDs:selRecordIDsArr.join("^"),
						UserID:session['LOGON.USERID']
					},function(rtn){
						if (rtn ==0){
							$('#tabNCPAccompanyRec').datagrid("reload");
						}else{
							$.messager.popover({msg:'ɾ��ʧ�ܣ�'+rtn,type:'error'});
						}
					})
				}
			});	
		}
	},'-',{
		text: '��ӡ�㻤֤',
		iconCls: 'icon-print',
		handler: function() {
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			if (rows.length ==0) {
				$.messager.popover({msg:'��ѡ����Ҫ��ӡ�㻤֤�ļ�¼��',type:'error'});
				return false;
			}
			var selNCPARRowIDArr=[];
			for (var i=0;i<rows.length;i++){
				var AccompanyStatus=rows[i].NCPARAccompanyStatus;
				if (AccompanyStatus!="Y") continue;
				var NCPARRowID=rows[i].NCPARRowID;
				selNCPARRowIDArr.push(NCPARRowID);
			}
			if (!selNCPARRowIDArr.length) {
				$.messager.popover({msg:'��ѡ����Ч���㻤��¼��ӡ��',type:'error'});
				return false;
			}
			PrintAccompanyRec(selNCPARRowIDArr.join("^"),"N");
		}
	},{
		text: '�㻤��Ա����¼��',
		iconCls: 'icon-print',
		handler: function() {
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			if (rows.length ==0) {
				$.messager.popover({msg:'δѡ���㻤��Ϣ,��ѡ��һ����Ҫ�޸ĵ��㻤��Ϣ��',type:'error'});
				return false;
			}else if(rows.length >1){
				$.messager.popover({msg:'ѡ���ж�����Ϣ����ֻѡ������һ��',type:'error'});
				return false;
			}
			ShowNCPAccompanyWriteWin(rows[0]);
		}
	}/*{
		text: '��ӡ�հ��㻤֤',
		iconCls: 'icon-print',
		handler: function() {
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			if (!rows.length) {
				$.messager.popover({msg:'��ѡ����Ҫ��ӡ�հ��㻤֤�ļ�¼��',type:'error'});
				return false;
			}
			var selEpisodeIDArr=[];
			for (var i=0;i<rows.length;i++){
				//var AccompanyStatus=rows[i].AccompanyStatus;
				//if (AccompanyStatus!="Y") continue;
				var EpisodeID=rows[i].episodeID;
				selEpisodeIDArr.push(EpisodeID);
			}
			if (!selEpisodeIDArr.length) {
				$.messager.popover({msg:'��ѡ����Ч���㻤��¼��ӡ��',type:'error'});
				return false;
			}
			PrintAccompanyRec(selEpisodeIDArr.join("^"),"Y");
		}
	}*/,'-'];
	
	///2021/8/5 ��̬��ȡ������ Ժ��ID,����code,����ģ��code��
	var ColumnsJson = tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetNCPAccompanyTableData",session['LOGON.HOSPID'],"P","PAT@ACP");
	var Columns=JSON.parse(ColumnsJson)
	$('#tabNCPAccompanyRec').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"index", //NCPARRowID
		pageSize: 30,
		pageList : [30,50,100,200],
		columns :Columns,
		//className:"Nur.NIS.Service.Accom.NCPAccompany",
		//queryName:"GetNCPAccompanyTableData", 
		toolbar :ToolBar,
		autoRowHeight:true,
		url : $URL+"?ClassName=Nur.NIS.Service.Accom.NCPAccompany&QueryName=GetNCPAccompanyRecord",
		onLoadSuccess:function cellStyleFun(arrStore){
            var trs = $(this).prev().find('div.datagrid-body').find('tr');
            for (var row = 0; row < trs.length; row++) {
	            for (var col = 0; col < trs[row].cells.length; col++) {
	                if (trs[row].cells[col].firstChild.innerHTML =="��"){
		                trs[row].cells[col].style.cssText = 'background:#f00;color:#fff';
	                }
	            }
            }
            /*if ((ServerObj.defEpisodeID !="")&&(arrStore.rows.length>0)&&(arrStore.rows[0].NCPARRowID=="")){
	            $('#tabNCPAccompanyRec').datagrid("selectRow",0);
	            AddNCPAccompanyRec();
	        }*/
		},
		onBeforeLoad:function(param){
			PageLogicObj.m_selAccompanyRecId="";
			$('#tabNCPAccompanyRec').datagrid("unselectAll"); 
			var Active=$("#Active").checkbox("getValue");
			var InActive=$("#InActive").checkbox("getValue");
			if ((Active)&&(InActive)) {
				var Status="A";
			}else if((!Active)&&(!InActive)){
				var Status="";
			}else {
				if (Active) var Status="Y";
				else var Status="N";
			}
			param = $.extend(param,{
				AccompanySearch:$("#NCPAccompanyRecSearch").searchbox("getValue"),
				Status:Status,
				wardId:ServerObj.wardId,
				GroupId:session['LOGON.GROUPID'],
				UserID:session['LOGON.USERID'],
				HospId:session['LOGON.HOSPID'],
				defEpisodeID:ServerObj.defEpisodeID,
				regNoSearch:$("#regNoSearch").searchbox('getValue'),
			});
		},
		onDblClickRow:function(rowIndex, rowData){
			$('#tabNCPAccompanyRec').datagrid("selectRow",rowIndex);
			ShowNCPAccompanyRecWin(rowData);
		},
		onDblClickHeader:function(){
			//ʹ�����´��붨�嵼�����ӡ����
			// CONTEXT=K����:Query��&PAGENAME=�������&PREFID=0
			window.open("websys.query.customisecolumn.csp?CONTEXT=KNur.NIS.Service.Accom.NCPAccompany:GetNCPAccompanyRecord&PAGENAME=NCPAccompanyRecord&PREFID=0");
		}
	})
	$("#NCPAccompanyRec_toolbar").appendTo($("#NCPAccompanyRecPanel .datagrid-toolbar tr"))
}

/*function InitNCPAccompanyRecEditWin(){
    $("#NCPAccompanyRecEditWin").window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetNCPAccompanyRecEditWinData();
	   }
	});
}*/
function InitNCPAccompanyRecSubEditWin(){
    $("#NCPAccompanyRecSubEditWin").window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetNCPAccompanySubEditWinData();
	   }
	});
}
/**
* @description ����㻤¼������
*/
/*function SetNCPAccompanyRecEditWinData() {
	 $("#bedCode").combobox("select","").combobox("enable");;
	 $("input[id^='NCPA']").each(function(index){
		  var input = $(this);
		  var id=input.attr('id');
		  if ((id!=undefined)&&(id.indexOf("NCPA")>-1)){
	         input.val("");
	     }
	     if(id.indexOf("_")>-1){
		     $("#"+id).radio("uncheck");
		 }
	 })
	 $("#NCPARAccompanyStatus_Yes").radio("check");
}*/
/**
* @description ����㻤����¼������
*/
function SetNCPAccompanySubEditWinData(){
	 $("input[id^='NCPARecInfo']").each(function(index){
		  var input = $(this);
		  var id=input.attr('id');
		  if ((id!=undefined)&&(id.indexOf("NCPARecInfo")>-1)){
	         input.val("");
	     }
	     if(id.indexOf("_")>-1)
	     {
		     $("#"+id).radio("uncheck");
		 }
	 })
}

function ShowNCPAccompanyRecWin(row){
	if(row.NCPARRowID == '') return;
	PageLogicObj.m_selAccompanyRecId=row.NCPARRowID;
	/*$("#bedCode").combobox("select",row.episodeID).combobox("disable");
	arr=[]
	$.each(row, function(key,value) {
    	arr[key]=value;
    	arr[key+"_"+value]=value;
    });
	$("input[class^='hisui-radio']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).radio("check");
	  	}
	})
	$("input[class^='hisui-datebox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).datebox("setValue",arr[obj["id"]]);
	  	}
	})
	$("input[class^='hisui-timespinner']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	$("input[class^='textbox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	row.NCPARAccompanyStatus =="Y"?$("#NCPARAccompanyStatus_Yes").radio("check"):$("#NCPARAccompanyStatus_No").radio("check")
	$("#NCPAccompanyRecEditWin").window({ iconCls : 'icon-w-edit',title:'�޸��㻤��Ϣ' }).window('open');*/
	var paramObj={
		title:$g("�޸��㻤��Ϣ"),
		iconCls:"icon-w-edit",
		EpisodeID:row.episodeID,
		bedEnable:"N",
	}
	showNCPaccompanyEditWin(paramObj);
}
function ShowNCPAccompanyWriteWin(row){
	if(row.NCPARRowID == ''){
		$.messager.popover({msg:'����Ч�㻤��¼',type:'error'});
		 return;
	}
	PageLogicObj.m_selAccompanyRecId=row.NCPARRowID;
	arr=[]
	$.each(row, function(key,value) {
    	arr[key]=value;
    	arr[key+"_"+value]=value;
    	arr[key+"Info"]=value;
    });
	$("input[class^='hisui-radio']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).radio("check");
	  	}
	})
	$("input[class^='hisui-datebox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).datebox("setValue",arr[obj["id"]]);
	  	}
	})
	$("input[class^='hisui-timespinner']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	$("input[class^='textbox']").each(function(index,obj){
	  	if(arr[obj["id"]]){
			$("#"+obj["id"]).val(arr[obj["id"]]);
	  	}
	})
	setDefaultValue("T","TEMP")
	var winH=$("#NCPAccompanyRecSubEditWin").height()+37;
	$("#NCPAccompanyRecSubEditWin").window({ 
		height:(HISUIStyleCode=="lite")?(winH-4):winH,
		iconCls : 'icon-w-edit',
		title:$g('�㻤��Ա�����Ǽ�')
	}).window('open');
	setTableStyle();
}

function NCPAccompanyRecSearchClick(){
	$('#tabNCPAccompanyRec').datagrid("reload");
}
function InitNCPAccompanyRecEditWinData(){
	InitBedNo();
	//InitAccompanySex();
}
function InitBedNo(){
	var JsonData=$.cm({
        ClassName:"Nur.NIS.Service.Base.Ward",
        MethodName:"GetWardPatients",
        wardID:ServerObj.wardId,
        adm:"", 
        groupSort:false,
        babyFlag:"",
        groupID:session['LOGON.GROUPID'],
        userID:session['LOGON.USERID']
    },false)
    for (var i=0;i<JsonData.length;i++){
        if (("^��λ^�Ⱥ���^").indexOf("^"+JsonData[i].label+"^")>=0){
            //PageLogicObj.m_PatientListJson=JsonData[i].children;
            //break;
            PageLogicObj.m_PatientListJson=PageLogicObj.m_PatientListJson.concat(JsonData[i].children);
        }
    }
	$("#bedCode").combobox({
		valueField:'episodeID',
		textField:'label',
		mode: "local",
		data:PageLogicObj.m_PatientListJson,
		//disabled:ServerObj.defEpisodeID?true:false,
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$("#patAge,#patName,#regNo").val("").removeAttr("disabled");
			}
		},
		onSelect:function(record){
			if (record) {
				$("#patAge").val(record.age).attr("disabled","disabled");
				$("#patName").val(record.name).attr("disabled","disabled");
				$("#regNo").val(record.regNo).attr("disabled","disabled");
				//2021-08-10
				var Result=tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetNCPAccompanyControl",record.episodeID,session['LOGON.HOSPID']);
				if(Result=="Y"){
					$.messager.popover({msg:'����δ���㻤ҽ��!',type:'error'});
					$("#BSave").hide()
					$("#BSavePrint").hide()
				}
				else{
					$("#BSave").show()
					$("#BSavePrint").show()					
				}

			}
		}
	})
}
function InitAccompanySex(){
	$("#AccompanySex").combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.CTSex&QueryName=GetDataForCmb1&ResultSetType=array&rowid=&code=&desc=",
		valueField:'CTSEXRowId',
		textField:'CTSEXDesc',
		mode: "remote",
		editable:false
	})
}
function PrintAccompanyRec(RecordIDS,BlankAccompany){
	try {
		DHCP_GetXMLConfig("InvPrintEncrypt","NCPTie");
		$.cm({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"GetNCPAccompanyPrintData",
			RecordIDS:RecordIDS,
			BlankAccompany:BlankAccompany
		},function(JsonData){
			for (var i=0;i<JsonData.length;i++){
				var MyPara = "" + String.fromCharCode(2);
				for (Element in JsonData[i]){
					MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + JsonData[i][Element];
				}
				DHC_PrintByLodop(getLodop(),MyPara,"","","");
			}
		})
	} catch(e) {alert(e.message)};
}
/*function SaveNCPAccompanyRec(callback){
	var episodeID=$("#bedCode").combobox("getValue");
	if (!episodeID) {
		$.messager.popover({msg:'��ѡ���ߴ��ţ�',type:'error'});
		$("#bedCode").next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($("#bedCode").combobox("getData"),"episodeID",episodeID)<0){
		$.messager.popover({msg:'������������ѡ���ߴ��ţ�',type:'error'});
		$("#bedCode").next('span').find('input').focus();
		return false;
	}
	var NCPARIdNo=$("#NCPARIdNo").val();
	if (!NCPARIdNo) {
		$.messager.popover({msg:'����д�㻤�����֤�ţ�',type:'error'});
		$("#NCPARIdNo").focus();
		return false;
	}else if(!DHCWeb_IsIdCardNo(NCPARIdNo)){
		$("#NCPARIdNo").focus();
		return false;
	}
	var AccompanyActive=$("#NCPARAccompanyStatus_Yes").radio("getValue")?"Y":"N";
	var SaveDataArr={},SaveNameArr={}
	$('input, select, textarea').each(function(index){
	     var input = $(this);
	     var id=input.attr('id');
	     var value=undefined;
	     var type=input.attr('type');
	     var hidden=input.attr('hidden');
	     var name=input.attr("name");
	     if ((id!=undefined)&&(type!=undefined)){
              if (type=='textbox' && hidden!='hidden'){
                  value=input.textbox('getValue');
              }else if (type=='combobox'){
                  value=input.combobox('getValue');
              }else if (type=='checkbox'){
                  if (input.is(':checked')) value=input.attr('xtext');
              }else if (type=='radio'){
                  //value=input.radio("getValue");
                  value="";
                  var id=name;
                  var _$sel=$("input[name='"+name+"']:checked");
                  if (_$sel.length>0){
	                  var selId=_$sel[0].id;
	                  value=selId.split("_")[1];
	              }
              }else if (type=='datetext'){
                  value=input.datebox("getValue")
              }else if (type!='button'){
                  value=input.val();                       
              }
              SaveDataArr[id]=value;
	     }
	});
	SaveDataArr["episodeID"]=episodeID;
	SaveDataArr["NCPARIdNo"]=NCPARIdNo;
	SaveDataArr["NCPARPaPmiDR"]="";
	SaveDataArr["AccompanyActive"]=AccompanyActive;
	var RepeatCredNoRecFlag= tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetRepeatCredNoRec",episodeID,PageLogicObj.m_selAccompanyRecId,NCPARIdNo);
	if (RepeatCredNoRecFlag =="Y"){
		$.messager.popover({msg:'���֤��:'+NCPARIdNo+"���Ǹû����㻤��Ա��",type:'error'});
		return false;
	}
	var deleteFlag= tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "getIfActiveRec",episodeID,session['LOGON.HOSPID']);
	var Msg="";
	if ((!PageLogicObj.m_selAccompanyRecId)&&(deleteFlag=="Y")) {
		var Msg="ȷ����������״̬���㻤��¼��?�������Ѵ�����Ч���㻤��¼�����������Զ�ͣ�ã�";
	}
	if (Msg!=""){
		$.messager.confirm('��ʾ', Msg, function(r){
			if (r) {
				save();
			}
		});
	}else{
		save();
	}
	function save(){
		var NCPARRowID=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"SaveNCPAccompanyRec",
			RecordID:PageLogicObj.m_selAccompanyRecId,
			SaveDataArr:JSON.stringify(SaveDataArr),
			UserID:session['LOGON.USERID']
		},false)
		if (NCPARRowID>0) {
			$('#tabNCPAccompanyRec').datagrid("reload");
			$("#NCPAccompanyRecEditWin").window('close');
			if (callback) callback(NCPARRowID);
		}else{
			$.messager.popover({msg:'����ʧ�ܣ�'+rtn,type:'error'});
			return false;
		}
	}
}*/

//������Ϣ¼�� ֻ�����Ӧcodeֵ��NCPARecInfo1-10��
function SaveNCPAccompanyRecSub(callback){
	var SaveDataArr={}
	$('input, select, textarea').each(function(index){
	     var input = $(this);
	     var id=input.attr('id');
	     var value=undefined;
	     var type=input.attr('type');
	     var hidden=input.attr('hidden');
	     if ((id!=undefined)&&(type!=undefined)&&(id.indexOf("NCPARecInfo")>-1)){
	              if (type=='textbox' && hidden!='hidden'){
	                  value=$.trim(input.val());//input.textbox('getValue');
	              }else if (type=='combobox'){
	                  value=input.combobox('getValue');
	              }else if (type=='checkbox'){
	                  if (input.is(':checked')) value=input.attr('xtext');
	              }else if (type=='radio'){
	                  value=input.radio("getValue")
	              }else if (type=='datetext'){
	                  value=input.datebox("getValue")
	              }else if (type!='button'){
	                        value=input.val();                       
	              }
	              SaveDataArr[id]=value;
	     }
	});
	if($('#NCPASRecordDate')){
		var NCPASRecordDate=$('#NCPASRecordDate').datebox("getValue");
		var NCPASRecordTime=$('#NCPASRecordTime').timespinner("getValue");
		if (!NCPASRecordDate) {
			$.messager.popover({msg:'¼�����ڲ���Ϊ��',type:'error'});
			$('#NCPASRecordDate').next('span').find('input').focus();
			return false;
		}else{
			var tmpdate=myparser(NCPASRecordDate);
			var CurDate=new Date();
			var end=new Date(CurDate.getFullYear()+"/"+(CurDate.getMonth()+1)+'/'+ CurDate.getDate());
			if(tmpdate > end){
				$.messager.popover({msg:"¼������ӦС�ڵ��ڵ��죺"+myformatter(end)+"��",type:'error'});
				$('#NCPASRecordDate').next('span').find('input').focus();
				 return false;
			}
		}
		if (NCPASRecordTime==""){
			$.messager.popover({msg:"¼��ʱ�䲻��Ϊ�գ�",type:'error'});
			$('#NCPASRecordTime').focus();
			return false;
		}
		if (!IsValidTime(NCPASRecordTime)){
			$.messager.popover({msg:"¼��ʱ���ʽ����ȷ! ʱ:��,��11:05:02",type:'error'});
			$('#NCPASRecordTime').next('span').find('input').focus();
			return false;
		}
		if (dtseparator =="/"){
			var tmpdate=NCPASRecordDate.split("/")[2]+"-"+NCPASRecordDate.split("/")[1]+"-"+NCPASRecordDate.split("/")[0]
		}else{
			var tmpdate=NCPASRecordDate;
		}
		var timeStr=tmpdate+" "+NCPASRecordTime;
		if (+new Date() < +new Date(timeStr)) {
			$.messager.popover({msg:"¼��ʱ��Ӧ�����ڵ�ǰʱ�䣡",type:'error'});
			$('#NCPASRecordTime').next('span').find('input').focus();
			return false;
		}
		SaveDataArr["NCPASRecordDate"]=NCPASRecordDate;
		SaveDataArr["NCPASRecordTime"]=NCPASRecordTime;
	}
	save();
	function save(){
		var rtn=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"SaveNCPAccompanySub",
			RecordID:PageLogicObj.m_selAccompanyRecId,
			SubId:"",
			SaveDataArr:JSON.stringify(SaveDataArr),
			UserID:session['LOGON.USERID']
		},false)
		if (rtn=="0") {
			$('#tabNCPAccompanyRec').datagrid("reload");
			$("#NCPAccompanyRecSubEditWin").window('close');
			if (callback) callback();
		}else{
			$.messager.popover({msg:'����ʧ�ܣ�'+rtn,type:'error'});
			return false;
		}
	}
}

//���沢��ӡ
/*function SavePrintNCPAccompanyRec(){
	//var episodeID=$("#bedCode").combobox("getValue");
	SaveNCPAccompanyRec(function(NCPARRowID){
		PrintAccompanyRec(NCPARRowID,"N")
	});
}*/
/*function AccompanyCredNoBlur(){
	var CredNo=$("#NCPARIdNo").val().toUpperCase();
	if (CredNo){
		setAccomInfo(CredNo);
		return false;
	}
}
function AccompanyNoOnKeyDown(e){
	var key=websys_getKey(e);
	if (key==13){
		var AccompanyCredNo = $("#NCPARIdNo").val().toUpperCase();
		var AccompanyRegNo = $("#NCPARegNo").val();
		setAccomInfo(AccompanyCredNo,AccompanyRegNo); 
		return false;
	}
}
function setAccomInfo(mypId,regNo){
	if(mypId.indexOf(" ")>-1)
	{
		mypId=mypId.split(" ")[0];
	}
	
	var myary;
	if(mypId!="")
	{
		myary=DHCWeb_GetInfoFromId(mypId);
	}
	if (((mypId!="")&&(myary[0]=="1"))||(regNo!="")){
		var rtn=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"GetPatInfoByNo",
			RegNo:regNo,
			CredNo:mypId,
			logonHospID:session['LOGON.HOSPID']
		},false)
		if(rtn!="")
		{
			var arrInfo=JSON.parse(rtn)
			arr=[]
			$.each(arrInfo, function(key,value) {
		    	arr[value["colCode"]]=value["colValue"];
		    	arr[value["colCode"]+"_"+value["colValue"]]=value["colValue"];
		    });
		    
			$("input[class^='hisui-radio']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).radio("check");
			  	}
			})
			$("input[class^='hisui-datebox']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).datebox("setValue",arr[obj["id"]]);
			  	}
			})
			$("input[class^='hisui-timespinner']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).val(arr[obj["id"]]);
			  	}
			})
			$("input[class^='textbox']").each(function(index,obj){
			  	
			  	if(arr[obj["id"]])
			  	{
					$("#"+obj["id"]).val(arr[obj["id"]]);
			  	}
			})
		}
	}else{
		$("#AccompanyCredNo").focus();
		return false;
	}
}*/
function setDefaultValue(opType,colType)
{				
	//$("#NCPAInfo5").datebox("setValue",ServerObj.CurrentDate);
	//$("#NCPAInfo6").val(ServerObj.CurrentTime);
	//$("#NCPARAccompanyStatus_Yes").radio("check");
	$.cm({
		ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
		MethodName:"GetNCPAccompanyDefaultData",
		hospId:session['LOGON.HOSPID'],
		opType:opType,
		colTypeStr:colType
	},function(JsonData){
		for (var i=0;i<JsonData.length;i++){
			if(JsonData[i]["initValue"]!="")
			{	
				if(JsonData[i]["type"]=="��ѡ��")
				{
					$("#"+JsonData[i]["field"]+"_"+JsonData[i]["initValue"]).radio("check");
				}
				else if(JsonData[i]["type"]=="����")
				{
					$("#"+JsonData[i]["field"]).datebox("setValue",JsonData[i]["initValue"]); //ServerObj.CurrentDate
				}else if(JsonData[i]["type"]=="ʱ��")
				{
					$("#"+JsonData[i]["field"]).val(JsonData[i]["initValue"]); //ServerObj.CurrentTime
				}
			}
				
		}
		
	})
}

function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CompareDateNew(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;  
	} 
	return false;
}
/*function ReadPatInfoHandler(){
	try {
		var myHCTypeDR = "1";
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//���Դ�
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>***</Name><Sex>1</Sex><NationDesc>��</NationDesc><Birth>19620817</Birth><Address>����ʡ����������¥������ɽ������ί��*��**��***��</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split("^");
		if ((myAry.length > 1) && (myAry[0] == 0)) {
			var IDCardXML = myAry[1];
			var IDObj = new X2JS().xml_str2json(IDCardXML).IDRoot;
			$("#NCPARIdNo").val(IDObj["CredNo"]);
			$("#NCPAInfo1").val(IDObj["Name"]);
			var sex = "";
			switch (IDObj["Sex"]) {
				case "1":
					sex = "��";
					break;
				case "2":
					sex = "Ů";
					break;
				default:
			}
			$("#NCPAInfo2"+"-"+sex).radio("check");
			$("#NCPAInfo3").val(IDObj["Address"]);
		}
	} catch (e) {
		$.messager.popover({msg: "�����֤ʧ�ܣ�" + e.message, type: "error"});
	}
}
//���� δ����
function BtnReadCardHandler() {
	DHCACC_GetAccInfo7(CardNoCallBack);
}

function CardNoCallBack(myrtn){
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#UPCardNo").val(CardNo);
			CardInfoUpdLogTabDataGridLoad()
			event.keyCode=13;
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){
				$('#UPCardNo').focus();
			});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			//$("#UPCardNo").val(CardNo);
			//CardInfoUpdLogTabDataGridLoad()
			event.keyCode=13;
		default:
	}
}*/
function IsValidTime(time){
	if (time.split(":").length==3){
		var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
	}else if(time.split(":").length==2){
		var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
	}else{
		return false;
	}
	if(!TIME_FORMAT.test(time)) return false;
	return true;
}
function AddNCPAccompanyRec(){
	/*PageLogicObj.m_selAccompanyRecId="";
	$("#NCPAccompanyRecEditWin").window({ iconCls : 'icon-w-add',title:'�����㻤��Ϣ' }).window('open');
	var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
	if (rows.length ==0) {
		if (ServerObj.defEpisodeID) $("#bedCode").combobox('select',ServerObj.defEpisodeID).combobox("enable");
	}else{
		$("#bedCode").combobox('select',rows[0].episodeID).combobox("enable");
	}
	setDefaultValue("P","ACP");
	if (ServerObj.defEpisodeID){
		$("#bedCode").combobox("disable");
	}*/
	PageLogicObj.m_selAccompanyRecId="";
	var paramObj={
		title:$g("�����㻤��Ϣ"),
		iconCls:"icon-w-add",
		EpisodeID:"",
		bedEnable:"Y",
	}
	var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
	if (rows.length ==0) {
		if (ServerObj.defEpisodeID) paramObj.EpisodeID=ServerObj.defEpisodeID;
	}else{
		paramObj.EpisodeID=rows[0].episodeID;
	}
	if (ServerObj.defEpisodeID){
		paramObj.bedEnable="N";
	}
	showNCPaccompanyEditWin(paramObj);
}
function showNCPaccompanyEditWin(paramObj){
	/*var colTypeList=$.cm({
        ClassName:"Nur.HISUI.AccompanyConfig",
        MethodName:"getDisplayList",
        className:"CF.NUR.Accom.Config", property:"AccomColType"
    },false)
    var colDataTypeList=$.cm({
        ClassName:"Nur.HISUI.AccompanyConfig",
        MethodName:"getDisplayList",
        className:"CF.NUR.Accom.Config", property:"AccomColDataType"
    },false)
    var count1=4,count2=8;
	var totalHeight=((count1+count2)*65);
	if (HISUIStyleCode=="lite") {
		totalHeight= parseInt(totalHeight);
	}else{
		totalHeight= parseInt(totalHeight) + 4;
	}*/
	var TRCount=$.cm({
        ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
        MethodName:"GetNCPAccompanyInfoNum",
        hospId:session['LOGON.HOSPID'], opType:"P"
    },false)
	var MaxTRCount=12; //panel�����չʾ����
	if (TRCount>MaxTRCount) TRCount=MaxTRCount;
	var totalHeight=(TRCount*30)+((TRCount+1)*10);
	if (HISUIStyleCode=="lite") {
		totalHeight= parseInt(totalHeight) + 103;
	}else{
		totalHeight= parseInt(totalHeight) + 107;
	}
	websys_showModal({
		iconCls:paramObj.iconCls||"",
		url:"nur.hisui.ncpaccompanyedit.csp?EpisodeID="+paramObj.EpisodeID+"&wardId="+ServerObj.wardId+"&bedEnable="+paramObj.bedEnable+"&NCPARRowID="+PageLogicObj.m_selAccompanyRecId,
		title:paramObj.title||"",
		width:540,height:totalHeight,
		closable:true,
		CallBackFunc:function(){
			websys_showModal("close");
			$('#tabNCPAccompanyRec').datagrid("reload");
		},
		GetSelNCPAccompanyRec:function(){
			var rows = $("#tabNCPAccompanyRec").datagrid("getSelections");
			return rows[0];
		}
	})
}
function ExportClick(){
	var Active=$("#Active").checkbox("getValue");
	var InActive=$("#InActive").checkbox("getValue");
	if ((Active)&&(InActive)) {
		var Status="A";
	}else if((!Active)&&(!InActive)){
		var Status="";
	}else {
		if (Active) var Status="Y";
		else var Status="N";
	}
	 $.cm({
	     ExcelName:session['LOGON.HOSPDESC']+session['LOGON.CTLOCDESC']+"�㻤��Ա��Ϣ�ǼǼ�¼",
	     PageName:"NCPAccompanyRecord",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "Nur.NIS.Service.Accom.NCPAccompany",
	     QueryName : "GetNCPAccompanyRecord",
	     AccompanySearch:$("#NCPAccompanyRecSearch").searchbox("getValue"),
		 Status:Status,
		 wardId:ServerObj.wardId,
		 GroupId:session['LOGON.GROUPID'],
		 UserID:session['LOGON.USERID'],
		 HospId:session['LOGON.HOSPID'],
		 defEpisodeID:ServerObj.defEpisodeID,
	     rows:9999999
	 },false);
}
function NCPAccomRegNoSearchClick(){
	var regNo=$("#regNoSearch").searchbox("getValue");
	if (regNo!==""){
		if (regNo.length<10) {
			for (var i=(10-regNo.length-1); i>=0; i--) {
				regNo="0"+regNo;
			}
		}
	}
	$("#regNoSearch").searchbox("setValue",regNo);
	NCPAccompanyRecSearchClick();
}