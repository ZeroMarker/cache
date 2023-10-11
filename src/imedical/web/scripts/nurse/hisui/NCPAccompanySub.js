/**
* @author mw
* HISUI �¹��㻤����¼����js
*/
var PageLogicObj={
	m_selAccompanyRecId:"", //��ѡ�޸��㻤��¼ID
	m_PatientListJson:"",
	episodeIDs:"",	
	accRowIDs:""	
}
$(function() {
	/**
	* @description ��ʼ��UI
	*/
	function initUI() {
		//initLayout();
		//initSearchCondition();
		if (HISUIStyleCode=="lite"){
			$("#patient_search").css("background","#f5f5f5");
			$(".searchbox-button").css("background","#fff");
		}
		ResetDomSize();
		initPatientTree();
		initGridData();
		initDateBox()
		
		if (EpisodeID !== "") {
			//setPatientInfo(EpisodeID)
		}
		InitEvent();
		InitNCPAccompanyRecSubEditWin();
	}
	/**
	* @description �������ò���
	*/
	function initLayout() {
		if (SinglePatient == "1") {
			$('#patient_search').hide();
			$('#nrLayout').layout('panel','west').panel('resize',{width:0});
			$('#nrLayout').layout('resize');
		}
	}
	function ResetDomSize(){
		$("#patientListTree").panel('resize', {
		  	height:window.innerHeight-122
		});
		$("#NCPAccompanySubPanel-table").css('height',$("#NCPAccompanySubPanel").height()-52);
	}
	/**
	* @description ��ʼ���㻤����
	*/
	function initPatientTree() {
		$HUI.tree('#patientTree', {
			loader: function(param, success, error) {
				$cm({
					ClassName: "Nur.NIS.Service.Accom.NCPAccompany",
					MethodName: "getWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: EpisodeID,
					groupSort: $(".ant-switch-checked").length?"true":"false",
					babyFlag: '',
					searchInfo: $("#wardPatientSearchBox").searchbox("getValue"),
					locID: session['LOGON.CTLOCID']||''
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			},
			onLoadSuccess: function(node, data) {
				$('.man,.woman,.unman').css("background-size", "contain");
				var addIDAndText = function(node) {
					node.id = node.ID;
					node.text = node.label ;
					
					if ((typeof node.icons != 'undefined') && (!!node.icons)) {
						$.each(node.icons.reverse(), function(index, value){
							$("#patientTree > li > ul > li > div > span:contains(" + node.text + ")").after("<img style='margin:6px;' src='" + value + "'/>");
						});
					}
					if (node.children) {
						node.children.forEach(addIDAndText);
					}
				}
				data.forEach(addIDAndText);
				if (!!EpisodeID) {
					var selNode = $('#patientTree').tree('find', EpisodeID);
					if(selNode)
					{
						$('#patientTree').tree('check', selNode.target);
					}
				}
			},
			lines: true,
			checkbox:true,
			onClick: function (node) {
				if (!!node.episodeID) {
					var flag = 0;
					$.each($('#patientTree').tree('getChecked'),function(index,object){
						if(object["episodeID"] == node.id)
						{
							$('#patientTree').tree('uncheck', node.target);
							flag = 1;
						}
					})
					if (flag == 0)	{	
						$('#patientTree').tree('check', node.target);
					}	
				}
			},
			onCheck: function(node) {		
				PageLogicObj.accRowIDs=""
				$.each($('#patientTree').tree('getChecked'),function(index,object){
					if(object["rowId"]){
						if(PageLogicObj.accRowIDs==""){
							PageLogicObj.accRowIDs=object["rowId"];
						}else{
							PageLogicObj.accRowIDs=PageLogicObj.accRowIDs+"^"+object["rowId"];
						}
					}
				})
				//if(PageLogicObj.accRowIDs!=""){
					$('#tabNCPAccompanySub').datagrid("reload");
				//}
            }
		});
	}
	/**
	* @description �б�����
	*/
	function initGridData() {
	var ToolBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
			var rows = $("#tabNCPAccompanySub").datagrid("getSelections");
			if (rows.length ==0) {
				$.messager.popover({msg:'δѡ���㻤��Ϣ,��ѡ��һ����Ҫ�������㻤��Ϣ��',type:'error'});
				return false;
			}else if(rows.length >1){
				$.messager.popover({msg:'ѡ���ж�����Ϣ����ֻѡ������һ��',type:'error'});
				return false;
			}
			clearData();
			setDefaultValue("T","TEMP")
			ShowNCPAccompanyWriteWin(rows[0],"add");
		}
		},{
			text: '�޸�',
			iconCls: 'icon-write-order',
			handler: function() {
				var rows = $("#tabNCPAccompanySub").datagrid("getSelections");
				if (rows.length ==0) {
					$.messager.popover({msg:'δѡ���㻤��Ϣ,��ѡ��һ����Ҫ�޸ĵ��㻤��Ϣ��',type:'error'});
					return false;
				}else if(rows.length >1){
					$.messager.popover({msg:'ѡ���ж�����Ϣ����ֻѡ������һ��',type:'error'});
					return false;
				}
				clearData();
				setDefaultValue("T","TEMP")
				ShowNCPAccompanyWriteWin(rows[0],"edit");
			}
		},{
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function() {
				var rows = $("#tabNCPAccompanySub").datagrid("getSelections");
				if (rows.length ==0) {
					$.messager.popover({msg:'δѡ����Ҫɾ�����㻤������Ϣ��¼��',type:'error'});
					return false;
				}
				var selRecordIDsArr=[];
				for (var i=0;i<rows.length;i++){
					if(rows[i].NCPARRowID == '') continue;
					if(rows[i].NCPARSub == '') continue;
					selRecordIDsArr.push(rows[i].NCPARRowID+"||"+rows[i].NCPARSub);
				}
				
				$.messager.confirm('ȷ�϶Ի���', 'ɾ���󲻿ɻָ���ȷ������ɾ����?', function(r){
					if (r){
						$.m({
							ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
							MethodName:"DelCNCPAccompanySub",
							RecordIDs:selRecordIDsArr.join("^"),
							UserID:session['LOGON.USERID']
						},function(rtn){
							if (rtn ==0){
								$('#tabNCPAccompanySub').datagrid("reload");
							}else{
								$.messager.popover({msg:'ɾ��ʧ�ܣ�'+rtn,type:'error'});
							}
						})
					}
				});	
			}
		}]
		///2021/8/11 ��̬��ȡ������
		var ColumnsJson = tkMakeServerCall("Nur.NIS.Service.Accom.NCPAccompany", "GetNCPAccompanyTableData",session['LOGON.HOSPID'],"T","ACP@TEMP");
		var Columns=JSON.parse(ColumnsJson)
	
		$('#tabNCPAccompanySub').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : false,
			singleSelect : false,
			fitColumns : false,
			loadMsg : '������..',  
			pagination : true, 
			rownumbers : true,
			idField:"NCPARSRowID",
			pageSize: 15,
			pageList : [15,50,100,200],
			columns :Columns,
			//className:"Nur.NIS.Service.Accom.NCPAccompany",
			//queryName:"GetNCPAccompanyTableData", 
			toolbar :ToolBar,
			autoRowHeight:true,
			url : $URL+"?ClassName=Nur.NIS.Service.Accom.NCPAccompany&QueryName=GetNCPAccompanySub",
			onBeforeLoad:function(param){
				PageLogicObj.m_selAccompanyRecId="";
				$('#tabNCPAccompanySub').datagrid("unselectAll"); 
				var stdate=$("#stDate").datebox("getValue");
				var eddate=$("#edDate").datebox("getValue");
				param = $.extend(param,{NCPARRowIDs:PageLogicObj.accRowIDs,hospId:session['LOGON.HOSPID'],stDate:stdate,edDate:eddate});
			},
			onDblClickRow:function(rowIndex, rowData){
				ShowNCPAccompanyRecWin(rowData);
			}
		})
		$("#NCPAccompanyRec_toolbar").appendTo($("#NCPAccompanyRecPanel .datagrid-toolbar tr"))
	}
	/**
	* @description ��ʼ�����ڿؼ�
	*/	
	function initDateBox()
	{
		//var curDate=myformatter(new Date());
		$("#stDate").datebox("setValue",ServerObj.CurrentDate);
		$("#edDate").datebox("setValue",ServerObj.CurrentDate);
	}
	function myformatter(date){
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
		else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}		
	function InitEvent(){
		$("#SubRecSave").click(SaveNCPAccompanyRecSub);
		/*$("#wardPatientSearchBox").keydown(function(e){
			var key=websys_getKey(e);
			if (key==13){
				$HUI.tree('#patientTree','reload');
			}
		});
		$("#wardPatientSearchBtn").click(function(){
			$HUI.tree('#patientTree','reload');
		});*/
		$('#wardPatientSearchBox').searchbox({
			searcher: function(value) {
				$HUI.tree('#patientTree','reload');
			}
		});
		$("#switchBtn").click(function(){
			$(".current").removeClass("current");
			if ($(".ant-switch-checked").length) {
				$("#switchBtn").removeClass("ant-switch-checked");
				$($(".switch label")[0]).addClass("current");
			}else{
				$("#switchBtn").addClass("ant-switch-checked");
				$($(".switch label")[1]).addClass("current");
			}
			$HUI.tree('#patientTree','reload');
		});
	}
		
	function ShowNCPAccompanyWriteWin(row,type){
		PageLogicObj.m_selAccompanyRecId=row.NCPARRowID;
		$("#NCPASRecordDate").datebox("setValue",ServerObj.CurrentDate);
		$("#NCPASRecordTime").val(ServerObj.CurrentTime);
		arr=[];	
		$.each(row, function(key,value) {
		    arr[key]=value;
		    arr[key+"_"+value]=value;
		    arr[key+"Info"]=value;
		});
		if(type == 'edit')
		{
			PageLogicObj.m_selNCPARSub=row.NCPARSub;			

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
		else
		{
			PageLogicObj.m_selNCPARSub="";
			$("input[class^='textbox']").each(function(index,obj){
			  	
			  	if((arr[obj["id"]])&&(obj["id"].indexOf("NCPARecInfo")<0))
			  	{
					$("#"+obj["id"]).val(arr[obj["id"]]);
			  	}
			})
			//$("#NCPARecInfo2_��").radio("check");
			//$("#NCPARecInfo3_��").radio("check");

		}
		
		
		//$("#bedCode").combobox("select",row.episodeID);

		var winH=$("#NCPAccompanyRecSubEditWin").height()+37;
		$("#NCPAccompanyRecSubEditWin").window({ 
			height:(HISUIStyleCode=="lite")?(winH-4):winH,
			iconCls : 'icon-w-edit',
			title:'�㻤��Ա�����Ǽ�' 
		}).window('open');
		setTableStyle();
		//$("#NCPAccompanyRecSubEditWin").window({ iconCls : 'icon-w-edit',title:'�㻤��Ա�����Ǽ�' }).window('open');
	}
	/**
	* @description ˢ��ģ����
	*/
	function refreshTree() {
		$HUI.tree('#savedTemplateTree','reload');
	}

//������Ϣ¼�� ֻ�����Ӧcodeֵ��NCPARecInfo1-10��
function SaveNCPAccompanyRecSub(callback){
	var NullValNCPARecInfoArr=[];
	var SaveDataArr={}
	$('input, select, textarea').each(function(index){
	     var input = $(this);
	     var id=input.attr('id');
	     var value=undefined;
	     var type=input.attr('type');
	     var hidden=input.attr('hidden');
	     if ((id!=undefined)&&(type!=undefined)&&(id.indexOf("NCPARecInfo")>-1)){
              if (type=='textbox' && hidden!='hidden'){
                  value=input.val();//input.textbox('getValue');
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
              if (value ==="") {
	              NullValNCPARecInfoArr.push($("label[for="+id.split("_")[0]+"]")[0].innerHTML);
	          }
              SaveDataArr[id]=value;
	     }
	});
	if (NullValNCPARecInfoArr.length > 0){
		$.messager.popover({msg:NullValNCPARecInfoArr.join("��")+"����Ϊ��!",type:'error'});
		return false;
	}
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
		SaveDataArr["NCPASRecordTime"]=NCPASRecordTime
	}
	save();
	function save(){
		var rtn=$.m({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"SaveNCPAccompanySub",
			RecordID:PageLogicObj.m_selAccompanyRecId,
			SubId:PageLogicObj.m_selNCPARSub,
			SaveDataArr:JSON.stringify(SaveDataArr),
			UserID:session['LOGON.USERID']
		},false)
		if (rtn=="0") {
			$('#tabNCPAccompanySub').datagrid("reload");
			$("#NCPAccompanyRecSubEditWin").window('close');
			clearData();
			if (callback) callback();
		}else{
			$.messager.popover({msg:'����ʧ�ܣ�'+rtn,type:'error'});
			return false;
		}
	}
}
	/**
	* @description ���¼������
	*/
	function clearData() {
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
	/**
	* @description ��ʼ��
	*/
	function setDefaultValue(opType,colType)
	{				
		$.cm({
			ClassName:"Nur.NIS.Service.Accom.NCPAccompany",
			MethodName:"GetNCPAccompanyDefaultData",
			hospId:session['LOGON.HOSPID'],
			opType:opType,
			colTypeStr:colType
		},function(JsonData){
			for (var i=0;i<JsonData.length;i++){
				if(JsonData[i]["initValue"]!=""){	
					if(JsonData[i]["type"]=="��ѡ��"){
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
	function NCPAccompanyRecSearchClick(){
		$('#tabNCPAccompanySub').datagrid("reload");
	}

	/**
	* @description ���url
	* @param {url} ģ�����ӵ�ַ
	*/
	function serilizeURL(url){
		var rs=url.split("?")[1];
		var arr=rs.split("&");
		var json={};
		json["csp"] = url.split("?")[0];
		for(var i=0;i<arr.length;i++){
			if(arr[i].indexOf("=")!=-1){
				json[arr[i].split("=")[0]]=arr[i].split("=")[1];
			}
			else{
				json[arr[i]]="undefined";
			}
		}
		return json;
	}

	/**
	* @description  �б���չ�Զ���չ���
	* @param {flag} ������չ��־ 
	*/
	function autoResizeTable(flag) {
		var tabs = $('#recordTabs').tabs('tabs');
		for (var i=0;i<tabs.length;i++) {
			var tab = tabs[i];
			var id = tab[0].children[0].id;
			var ifFunc = $.isFunction($('#' + id)[0].contentWindow.HisuiTableAutoAdaption);
			if (ifFunc) {
				$('#' + id)[0].contentWindow.HisuiTableAutoAdaption();
			}
		}
	}
	initUI();
	
	return NursingRecords = {
		InitSavedTemplateTree: refreshTree,
		AutoResizeTable: autoResizeTable
	};
});
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
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;  
	} 
	return false;
}
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
function InitNCPAccompanyRecSubEditWin(){
    $("#NCPAccompanyRecSubEditWin").window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true
	});
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