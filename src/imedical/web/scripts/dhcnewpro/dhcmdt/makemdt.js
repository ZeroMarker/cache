///QQA
///2019-04-17
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var editSelRow = -1;
var LType = "CONSULT";  /// ������Ҵ���
var MarFlag=""          /// �Ƿ�����רҵ
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
$(function() {
	
	initParams();  
	
	initShowPage();
    
    initCalenDar();
    
    if(!ShowPay){
		initTable();
	}
});

function initShowPage(){
	if(ShowPay){
		$('#mainLayout').layout('hidden','east');
	}	
}

function initParams(){
	var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    todayDate = curDate.getFullYear() + "-" + (curMonth < 10 ? "0" + curMonth : curMonth) + "-" + ((curDate.getDate() < 10) ? ("0" + curDate.getDate()) : curDate.getDate());	
	selObj={};
	
}

function initCalenDar() {
    $('#makeTmpCalendar').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,basicWeek,basicDay', //agendaWeek,agendaDay ��ȷʱ��ε���ͼ
        },
        defaultDate: todayDate,
        editable: false, // �����϶�
        lang: "zh-cn",
        monthNames: ["һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����"],
        monthNamesShort: ["һ��", "����", "����", "����", "����", "����", "����", "����", "����", "ʮ��", "ʮһ��", "ʮ����"],
        dayNames: ["����", "��һ", "�ܶ�", "����", "����", "����", "����"],
        dayNamesShort: ["����", "��һ", "�ܶ�", "����", "����", "����", "����"],
        today: ["����"],
        eventColor: "#40a2de",
        eventBorderColor: "white",
        height: 500, // ����߶�
        //contentHeight: 50, // �����ݵ��и�
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '����ͼ',
            basicWeek: '����ͼ',
            basicDay: '����ͼ'
        },
        // ��̬��ѯ
        events: function(start, end, timezone, callback) {
			runClassMethod("web.DHCMDTConsultQuery","GetMarkInfo",{CstID:CstID,DisGrpID:MdtDisGrp},function(jsonString){
	           	events = formatData(jsonString);
	            callback(events);
	            return;
			})
	        
            
        },
        eventClick: function(calEvent, jsEvent, view) {
	        var date = calEvent.start.format("YYYY-MM-DD");
	        var title = calEvent.title;
	        var appSclID = calEvent.appSclID
	        var trDesc = calEvent.trDesc;
	        var allNum = calEvent.allNum;
	        if(allNum==0){
		    	$.messager.alert("��ʾ","û�п�ԤԼ����Դ��");
		    	return;
		    }
	        var isSelStatus = $(this).hasClass("selMark");
			if(isSelStatus){
				$(this).removeClass("selMark");	
				selObj={};
			}else{
				$(".selMark").removeClass("selMark");
				$(this).addClass("selMark");
				selObj.date=date;
				selObj.title=title;
				selObj.appSclID=appSclID;
				selObj.trDesc = trDesc;
			}
			
			selItmFun();
			return;
    	}

    });
}

function formatData(datas){
	var retArr=[];
	for (i in datas){
		var backColor = "blue";
		var allNum = datas[i].AllNum;
		if(allNum==0) backColor ="#ccc"
		var obj={};
		obj.title = datas[i].TRDesc;
		obj.start = datas[i].ASDate;
		obj.color= backColor;
		obj.appSclID = datas[i].ASRowId
		obj.trDesc = datas[i].TRDesc;
		obj.allNum = allNum;
		retArr.push(obj);	
	}
	
	
   	return retArr;	
}

function selItmFun(){
	if(selObj.date!=undefined){
		var date = selObj.date;
		var title = selObj.title;
		var appSclID = selObj.appSclID;
		var trDesc = selObj.trDesc;
		if(ShowPay==1){
			window.parent.$("#mdtPreTime").val(date);
			window.parent.$("#mdtPreTimeRange").val(trDesc);
			window.parent.AppSclID = appSclID;
			window.parent.$("#mdtWin").window("close");
		}
	}else{
		
	}	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function initTable(){
	
	/// �༭��
	var texteditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	var HosTypeArr = [{"value":"I","text":'��Ժ'}, {"value":"O","text":'��Ժ'}];
	//������Ϊ�ɱ༭
	var HosEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: HosTypeArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'HosID'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'HosType'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	// ְ�Ʊ༭��
	var PrvTpEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonPrvTp",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			//panelHeight:"auto",  //���������߶��Զ�����
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
				$(ed.target).combobox('setValue', option.text);
				
				///���ü���ָ��
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val("");
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	// ���ұ༭��
	var LocEditor={
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			//url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+LgHospID,
			url: '',
			blurValidValue:true,
			onSelect:function(option) {
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				$(ed.target).val(option.value);

				///���ü���ָ��
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', "");
				
				/// ��ϵ��ʽ
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetLocTelPhone(option.value));
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocDesc'});
				var unitUrl = $URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&LType="+LType+"&LocID="+LgLocID+"&HospID="+LgHospID;
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// ��רҵ�༭��
	var MarEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				GetMarIndDiv(option.value, LocID); 	/// ȡ������רҵָ��
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'MarDesc'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsLocItem&MethodName=JsonSubMar&LocID="+ LocID;
				$(ed.target).combobox('reload',unitUrl);
			}
		}
	}
		
	// ҽʦ�༭��
	var DocEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url: "",
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			blurValidValue:true,
			onSelect:function(option){
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
				$(ed.target).val(option.value);
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				$(ed.target).combobox('setValue', option.text);
				
				/// ��ϵ��ʽ
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'TelPhone'});
				$(ed.target).val(GetCareProvPhone(option.value));
				
				$m({
					ClassName:"web.DHCEMConsultCom",
					MethodName:"GetPrvTpIDByCareProvID",
					CareProvID:option.value
				},function(txtData){
					var ctpcpCtInfo = txtData;
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTp'});
					$(ed.target).combobox('setValue', ctpcpCtInfo.split("^")[1]);
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
					$(ed.target).val(ctpcpCtInfo.split("^")[0]);
				});
			},
			onShowPanel:function(){
				
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'LocID'});
				var LocID = $(ed.target).val();
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'PrvTpID'});
				var PrvTpID = $(ed.target).val();
				///���ü���ָ��
				var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserName'});
				var unitUrl=$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&ProvType=DOCTOR&LocID="+ LocID+"&PrvTpID="+ PrvTpID+"&LgUserID="+ LgUserID;
				$(ed.target).combobox('reload',unitUrl);
			},
			onChange:function(newValue, oldValue){
				if (newValue == ""){
					var ed=$("#docTable").datagrid('getEditor',{index:editSelRow,field:'UserID'});
					$(ed.target).val("");
				}
			}
		}
	}
	
	///  ����columns
	var columns=[[
		{field:'PrvTpID',title:'ְ��ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'PrvTp',title:'ְ��',width:160,editor:PrvTpEditor,align:'center',hidden:false},
		{field:'HosID',title:'HosID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'HosType',title:'Ժ��Ժ��',width:110,editor:HosEditor,align:'center'},
		{field:'LocID',title:'����ID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'center'},
		{field:'MarID',title:'��רҵID',width:100,editor:texteditor,align:'center',hidden:true},
		{field:'MarDesc',title:'��רҵ',width:200,editor:MarEditor,align:'center'},
		{field:'UserID',title:'ҽ��ID',width:110,editor:texteditor,align:'center',hidden:true},
		{field:'UserName',title:'ҽ��',width:120,editor:DocEditor,align:'center'},
		{field:'TelPhone',title:'��ϵ��ʽ',width:130,editor:texteditor,align:'center'},
		{field:'operation',title:"����",width:100,align:'center',formatter:SetCellUrl}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		fitColumns:true,
		rownumbers : false,
		singleSelect : true,
		pagination: false,
		fit : false,
	    onDblClickRow: function (rowIndex, rowData) {
			
			if (isEditFlag == 1) return;
			
            if ((editSelRow != -1)||(editSelRow == 0)) { 
                $("#docTable").datagrid('endEdit', editSelRow); 
            }
            $("#docTable").datagrid('beginEdit', rowIndex); 
            
            /// ��ϵ��ʽ
			var ed=$("#docTable").datagrid('getEditor',{index:rowIndex,field:'TelPhone'});
			$(ed.target).attr("disabled", true);
			
            editSelRow = rowIndex;
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
            $("a[name='AddRow']").not("#"+(data.rows.length - 1)).hide();
            /// �Ƿ����û�����רҵ
            if (MarFlag != 1){
				$("#docTable").datagrid('hideColumn','MarDesc');
            }
        }
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID;
	new ListComponent('docTable', columns, uniturl, option).Init();
}

function getParams(){
	
}

/// ����
function SetCellUrl(value, rowData, rowIndex){	
	var html = "<a href='#' onclick='delRow("+ rowIndex +")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
	    html += "<a href='#' onclick='insRow()'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
	return html;
}

/// ɾ����
function delRow(rowIndex){
	
	if (isEditFlag == 1) return;
	/// �ж���
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'', HosType:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	
	/// ��ǰ��������4,��ɾ�����������
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	
	var rows = $('#docTable').datagrid('getRows');
	if(rows.length>2){
		 $('#docTable').datagrid('deleteRow',rowIndex);
	}else{
		$('#docTable').datagrid('updateRow',{index:rowIndex, row:rowObj});
	}
	
	// ɾ����,��������
	//$('#docTable').datagrid('sort', {sortName: 'No',sortOrder: 'desc'});
	
	GetMarIndDiv("", ""); 	/// ȡ������רҵָ��
}

/// �������
function insRow(){
	
	if (isEditFlag == 1) return;
			
    var rowObj={PrvTpID:'', PrvTp:'', HosID:'I', HosType:'��Ժ', LocID:'', LocDesc:'', MarID:'', MarDesc:'', UserID:'', UserName:'', TelPhone:''};
	$("#docTable").datagrid('appendRow',rowObj);
}


/// ȡ���ҵ绰
function GetLocTelPhone(LocID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetLocTelPhone",{"LocID":LocID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}

/// ȡҽ���绰
function GetCareProvPhone(CareProvID){
	
	var TelPhone = "";
	runClassMethod("web.DHCEMConsultQuery","GetCareProvPhone",{"CareProvID":CareProvID},function(jsonString){

		//if (jsonString != ""){
			TelPhone = jsonString;
		//}
	},'',false)
	return TelPhone
}