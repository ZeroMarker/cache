var PageLogicObj = {
	OldID:"", //��һ��ѡ�е�Ԫ
	OldColor:"", //��һ��ѡ�е�Ԫ��ɫ
	nowmoth:"", //������ǰ��ʾ���·�
	rbasdr:"", //˫��ѡ����Դ��Ϣ
	tabApponitmentList:"",
	tabtimer:"",
	SelectAppMeth:"", //ѡ�е�ԤԼ��ʽ
	LockPatientID:""
}

$(function(){

	//ҳ��Ԫ�س�ʼ��
	PageHandle();
	
	//�¼���ʼ��
	InitEvent();
});
function BodyLoadHandler(){

	//���������Ϻ��ʼ������ģ��
	IntCalender()

	//ʱ��Ĭ��	
	$('#StartDay').datebox('setValue',ServerObj.NowDateHtml)

	$('#EdDate').datebox('setValue',ServerObj.NowDateHtml)

	//��ʼ���Ͳ�ѯ����һ��
	//setTimeout(function(){$('#FindLoc').combobox('setValue',session['LOGON.CTLOCID']);},100)
	setTimeout(function(){IntFindLoc()},100)
	//����
	$("#OCTloc").keyup(function (e){
			if ($("#OCTloc").val()==""){
				$('#OCTLocRowid').val('');
				/*$('#OMark').combobox('setValue','');
				$('#OMark').combobox('setText','');
				$('#OMark').combobox('clear');
				$('#OMark').combobox('loadData',{});*/
				$('#OMark').val('');
				$('#OMarkRowid').val('');
				//IntOMark()
				
			}
		}
	)
	document.onkeydown = DocumentOnKeyDown;
	try{
		var frmobj=dhcsys_getmenuform();
		if (frmobj){patdr=frmobj.PatientID.value}
	}catch(e){}
	setTimeout(function(){frames[0].LoadPage("",patdr,"",ServerObj.CanNoCardApp)},300)
}
function InitEvent(){
	//ԤԼ
	$('#BtnAppointment').bind('click',function(){BtnAppointment()})

   	//�������ѡ����Ϣ
   	$('#Clear').bind('click',function(){Clear()})
	//��ѯ
	$('#Find').bind('click',function(){LoadtabAppList()})
	//��ӡԤԼ��
	//$('#PrintAppInfo').click(PrintAppInfo)
	//ȡ��ԤԼ
	//$('#CancelApp').bind('click',function(){CancelApp()})
	//���
	$('#ClearFindMesage').bind('click',function(){ClearFindMesage()})
    //��������
	var Obj=document.getElementById("OCTloc")
  	if (Obj){
	  	Obj.onkeyup=OCTlocChangeHandler;
  	}
  	//�س��¼�
	$("#PatNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				PatNoSearch()
			}
		}
	)

	//�س��¼�
	$("#Name").keydown(function (e){
		var keycode = e.which;
		if(keycode==13){	
			LoadtabAppList()
		}
	  }
	)
	//�ǼǺŲ�ѯ����
	$("#PatNo").keyup(function (e){
			if ($('#PatNo').val()==""){
				$('#PatNo,#Name,#PatientID,#CardNo,#CardTypeNew').val('')
				$('#RBAS').combobox('setValue','');
				$('#RBAS').combobox('setText','');
				IntFindLoc()
			}
		}
	)
  	//�س��¼�
	$("#CardNo").keydown(function (e){
			var keycode = e.which;
			if(keycode==13){		
				CardNoKeyDownHandler()
			}
		}
	)

	//����
	$("#BReadCard").click(ReadCardClickHandler);

}

///��ԤԼ����
function BtnAppointment(){

	if (PageLogicObj.OldID==""){
		$.messager.alert("��ʾ","����ѡ��������Ϣ")
		return 
	}
	calendersearceAppoint(PageLogicObj.OldID)
}


function ClearFindMesage(){

	$('#PatNo').val('')
	$('#Name').val('')
	$('#PatientID').val('')
	$('#CardNo').val('')
	$('#CardTypeNew').val('')
	$('#RBAS').combobox('setValue','');
	$('#RBAS').combobox('setText','');
	$('#StartDay,#EdDate').datebox('setValue',ServerObj.NowDateHtml)
	IntFindLoc()


}
//�ǼǺŻس�
function PatNoSearch(){

	var patno=$("#PatNo").val()
	if ((patno.length<ServerObj.PatNumLength)&&(ServerObj.PatNumLength!=0)) {
		for (var i=(ServerObj.PatNumLength-patno.length-1); i>=0; i--) {
			patno="0"+patno;
		}


	}
	//�����������Ϣ
	ClearPatInfo()
	
	$("#PatNo").val(patno)
	var rtn=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getPatMesageByPatNo",
		dataType:"text",
		PatNo:patno,
		PatDr:"",
	},false);
	window.setTimeout("SetPatInfo('"+rtn+"')");
	
}

function ClearPatInfo(){

	$("#Name").val("")
	$("#PatientID").val("")
}

//���û�����Ϣ
function SetPatInfo(rtn) {
	if (rtn==""){
		$.messager.alert("��ʾ","������Ϣ��Ч��")
		return 
	}
	var rtnarry=rtn.split("^")
	$("#Name").val(rtnarry[2])
	$("#PatientID").val(rtnarry[0])
}

//���Żس�
function CardNoKeyDownHandler(){

	var CardNo=$("#CardNo").val();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","PatInfo",CardTypeCallBack);
	return false;
}

//�����¶�������
function ReadCardClickHandler(){

	//�°�
	DHCACC_GetAccInfo7(CardTypeCallBack);
}

//��������
function CardTypeCallBack(myrtn){


    var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()		
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч!","info",function(){
				$("#CardNo").focus();
			});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").val(CardNo);
			$("#PatNo").val(PatientNo);
			PatNoSearch()
			break;
		default:
	}
}


function PageHandle(){

	PageLogicObj.tabApponitmentList=IntApponitmentList()
	/*
	var tool=[
		{  
			text:'���',  
	    	iconCls:'icon-clear-screen',   
	    	handler:function(){Clear()}    
	  	}  
	]    
	var westpanel=$('#mainlayout').layout('panel','west'); 
	if (westpanel){
		westpanel.panel({ 
			tools:tool
		})
	}
	*/

	//��ʼ���ű�
   $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindDocMarkStr",
		userid:session['LOGON.USERID'],
		locid:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#MarkDoc", {
			valueField: 'resrowid',
			textField: 'markdesc', 
			data: jsonData.rows,
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["markdesc"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (rec) {
				PageLogicObj.rbasdr=rec.resrowid;
				$("#OCTloc").val('')
				$("#OCTLocRowid").val('')
				$('#OMark').val('');
				$('#OMarkRowid').val('');
				IntCalender()
				SetFindLocRBAS(session['LOGON.CTLOCID'],rec.resrowid)
				
			},
			onChange:function(newValue,oldValue){


			},
			onLoadSuccess:function(){
				if (jsonData.rows.length==1){
					var Selectvalue=jsonData.rows[0].resrowid
					$HUI.combobox("#MarkDoc").select(Selectvalue)
				}else if (jsonData.rows.length>1){
					for (var j=0;j<jsonData.rows.length;j++){
						if(jsonData.rows[j].MarkShowDesc==session['LOGON.USERNAME']){
							var Selectvalue=jsonData.rows[j].resrowid
							$HUI.combobox("#MarkDoc").select(Selectvalue)
							}
						}
					}
			}
	   });
    });	


  //��ʼ������
  $("#OCTloc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CTRowId',
        textField:'CTDesc',
        columns:[[  
            {field:'CTRowId',title:'',hidden:true},
			{field:'CTDesc',title:'��������',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCBL.Doctor.AppointOral',QueryName: 'GetOtherLocList'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{UserID:session['LOGON.USERID'], CTLOC:session['LOGON.CTLOCID'], desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					OCTlocLookupSelect(rec["CTDesc"]+"^"+rec["CTRowId"])	
				}else{
					
				}
			});
		}
    });
    IntOMark()
    
    //��ѯ�����÷Ŵ󾵴���
     $("#FindLoc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'CTRowId',
        textField:'CTDesc',
        columns:[[  
            {field:'CTRowId',title:'',hidden:true},
			{field:'CTDesc',title:'��������',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCDocAppointmentHui',QueryName: 'CanFindLoc'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{LogOnUser:session['LOGON.USERID'], LogOnLoc:session['LOGON.CTLOCID'], desc:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					$("#FindLocRowid").val(rec["CTRowId"])
					IntFindRBAS(rec["CTRowId"])	
				}else{
				}
			});
		}
    });
    
   
   
   
   //��ʼ��ԤԼ��ʽ
   $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"GetMethTypeDesc",
		userid:session['LOGON.USERID'],
		locid:session['LOGON.CTLOCID'],
		MethCodeStr:ServerObj.AppMethCodeStr,
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#MeathCodeList", {
			valueField: 'MethodCode',
			textField: 'MethodDesc', 
			data: jsonData.rows,
			filter: function(q, row){
		
			},
			onSelect: function (rec) {
				
			},
			onChange:function(newValue,oldValue){
				if ((newValue==undefined)||(typeof newValue==undefined)){newValue=""}
				PageLogicObj.SelectAppMeth=newValue
				IntCalender()
				
			},
			onLoadSuccess:function(){
					if (jsonData.rows.length==1){
						$('#MeathCodeList').combobox('setValue',jsonData.rows[0].MethodCode);
					}
					
					
			}
	   });
    });	
   
   


}

function SetFindLocRBAS(loc,rbas){
	$("#FindLocRowid").val(loc)
	var ctlocdesc = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"GetCtLocDescByID",
		dataType:"text",
		ctlocdr:loc
	},false);
	$('#FindLoc').val(ctlocdesc)
	IntFindRBAS(loc)
	setTimeout(function(){
	 	$('#RBAS').combobox('setValue',rbas);
	},1000)	
}

function IntFindRBAS(FindLoc){

  ///��ʼ��ԤԼ��ѯ�Ŀ���
  $.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"CanFindRBAS",
		locdr:FindLoc,
		logonuser:session['LOGON.USERID'],
		logonloc:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#RBAS", {
			valueField: 'rowid',
			textField: 'desc', 
			data: jsonData.rows,
			filter: function(q, row){
				q=q.toUpperCase();
				return (row["desc"].toUpperCase().indexOf(q) >= 0);
			},
			onSelect: function (rec) {
			
			},
			onChange:function(newValue,oldValue){
				
			},
			onLoadSuccess:function(){
			}
	   });
   });	

}

//�����������
function OCTlocChangeHandler(){
    var Obj=document.getElementById("OCTloc")
    if ((Obj)&&(Obj.value=="")){
	    var OCTLocRowidObj=document.getElementById("OCTLocRowid");


    	if (OCTLocRowidObj){
	    		OCTLocRowidObj.value="";
	    		/*$('#OMark').combobox('clear');
	    		$('#OMark').combobox('setValue','');
	    		$('#OMark').combobox('setText','');
	    		$('#OMark').combobox('loadData',{});*/
	    		$('#OMark').val('');
				$('#OMarkRowid').val('');
	    		PageLogicObj.rbasdr=""
	    		IntCalender();
	    }

	}
}

//ѡ����������
function OCTlocLookupSelect(value){
    var OCTLocRowidObj=document.getElementById("OCTLocRowid");


    if (OCTLocRowidObj){
	    OCTLocRowidObj.value=value.split("^")[1];
	    /*$('#OMark').combobox('clear');
	    $('#OMark').combobox('setValue','');
	    $('#OMark').combobox('setText','');
	    $('#OMark').combobox('loadData',{});*/
	    $('#OMark').val('');
		$('#OMarkRowid').val('');
	    $('#MarkDoc').combobox('setValue','');
	    $('#MarkDoc').combobox('setText','');
	    window.setTimeout('IntOMark()',1)


	}
}

///���������ű�
function IntOMark(){

   //var OCtlocDr=$("#OCTLocRowid").val()
   $("#OMark").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'resrowid',
        textField:'markdesc',
        columns:[[  
            {field:'resrowid',title:'',hidden:true},
			{field:'markdesc',title:'����',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        isCombo:true,
        //minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocAppointmentHui',QueryName: 'FindDocMarkStrOther'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{UserID:session['LOGON.USERID'], LocID:$("#OCTLocRowid").val(), LogOnLoc:session['LOGON.CTLOCID'], MarkCodeName:desc});
	    },
	    onSelect:function(index, rec){
		    setTimeout(function(){
				if (rec!=undefined){
					PageLogicObj.rbasdr=rec['resrowid'];
					IntCalender();
					SetFindLocRBAS(OCtlocDr,rec['resrowid'])
					$('#OMarkRowid').val(rec['resrowid']);
				}
			});
		}
    });
   /*$.cm({
		ClassName:"web.DHCDocAppointmentHui",
		QueryName:"FindDocMarkStrOther",
		UserID:session['LOGON.USERID'],
		LocID:OCtlocDr,
		LogOnLoc:session['LOGON.CTLOCID'],
		rows:99999
   },function(jsonData){
		var cbox = $HUI.combobox("#OMark", {
			valueField: 'resrowid',
			textField: 'markdesc', 
			data: jsonData.rows,
			filter: function(q, row){
		
			},
			onSelect: function (rec) {
				PageLogicObj.rbasdr=rec.resrowid;
				IntCalender();
				SetFindLocRBAS(OCtlocDr,rec.resrowid)
			},
			onChange:function(newValue,oldValue){
				
			},
			onLoadSuccess:function(){
				
			}
	   });
    });*/
    //���������Դ
    PageLogicObj.rbasdr=""
    IntCalender();
	$('#OMark').focus()
}

///������������Ϣ
function Clear(){

	$('#OMark').val('');
	$('#OMarkRowid').val('');
	$("#OCTloc").val('')
	$("#OCTLocRowid").val('')
	$('#MarkDoc').combobox('setValue','');
	$('#MarkDoc').combobox('setText','');
	PageLogicObj.rbasdr=""
	IntCalender();
}

//��ѯԤԼ��Ϣ
function LoadtabAppList(){


	if (PageLogicObj.tabApponitmentList==""){
		$.messager.alert("��ʾ","δ�ҵ���ʼ�������Ϣ.����ϵϵͳ����Ա!")
		return
	}

	//�Ƿ��ѯ����ҽ��ԤԼ��Դ
	var OterdocAppoint="N"
	var OterdocAppoint=$("#OterdocAppoint").checkbox('getValue')
	if (OterdocAppoint){
		OterdocAppoint="Y"
	}


	var rbasdr=$('#RBAS').combobox('getValue');
	if ($("#FindLoc").lookup('getText')==""){
		$("#FindLocRowid").val('');
	}
	//var Locdr=$('#FindLoc').combobox('getValue');
	var Locdr=$("#FindLocRowid").val()
	if (Locdr==undefined) Locdr="";
	if (Locdr==""){
		$.messager.alert("��ʾ","��ѡ�����!");
		return false;
	}
	//��ѯ֮ǰ�������ѡ��
	$('#tabApponitmentList').datagrid("unselectAll")
	$.cm({
	    ClassName :"web.DHCDocAppointmentHui",
	    QueryName :"GetApptList",
	    StartDay:$("#StartDay").datebox('getValue'),
	    EndDay:$("#EdDate").datebox('getValue'),
	    LogonLocId:session['LOGON.CTLOCID'],
	    LogOnUser:session['LOGON.USERID'],
	    MethCodeStr:ServerObj.AppMethCodeStr,
	    CanAddApponit:ServerObj.CanAddApponit,
	    PatientID:$("#PatientID").val(),
	    Locdr:Locdr,
	    RBResID:rbasdr,
	    PatName:$("#Name").val(),
	    OterdocAppoint:OterdocAppoint,
	    Pagerows:PageLogicObj.tabApponitmentList.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.tabApponitmentList.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);

	});

}

///��ʼ����ѯTable	
function IntApponitmentList(){

	var tabdatagrid=$('#tabApponitmentList').datagrid({  
	fit : true,
	border : false,
	striped : true,
	singleSelect : false,
	fitColumns : false,
	autoRowHeight : true,
	rownumbers:true,
	pagination : true,  
	rownumbers : true,
	toolbar: [{
		iconCls: 'icon-cancel',
		text:"ȡ��ԤԼ",
		handler: function(){CancelApp();}
	},{
		iconCls: 'icon-print',
		text:"��ӡԤԼ��",
		handler: function(){PrintAppInfo();}
	}],

	nowrap: false, //������
	pageSize: 20,
	pageList : [20,100,200],
	idField:"RowId",
	columns :[[ 
			{field:'RowCheck',checkbox:true},
			{field:'PatientNo',title:"�ǼǺ�",width:150,align:'left'},
			{field:'PatientName',title:"����",width:150,align:'left'},
			{field:'AppPatientSex',title:"�Ա�",width:80,align:'left'},
			{field:'AppPatientAge',title:"����",width:100,align:'left'}, 
			{field:'TPhone',title:"��ϵ�绰",width:150,align:'left'},
			{field:'AppDate',title:"ԤԼ����",width:150,align:'left'},
			{field:'DepDesc',title:"ԤԼ����",width:150,align:'left'},
			{field:'DocDesc',title:"ԤԼҽ��",width:150,align:'left'},
			{field:'MethodDesc',title:"ԤԼ��ʽ",width:120,align:'left'},
			{field:'QueueNo',title:"���",width:60,align:'left'},
			{field:'StatusDesc',title:"ԤԼ״̬",width:100,align:'left'},
			{field:'TransDate',title:"ԤԼ��������",width:120,align:'left'},
			{field:'TransTime',title:"ԤԼ����ʱ��",width:120,align:'left'},
			{field:'TransUserName',title:"ԤԼ������",width:100,align:'left'},
			{field:'Sum',title:"���",width:60,align:'left'},
			{field:'TTimeRange',title:"�������ʱ��",width:150,align:'left'},
			{field:'Remark',title:"ԤԼ��ע",width:150,align:'left'},
			


			{field:'TPoliticalLevel',title:"���˼���",width:100,align:'left',hidden:true},
			{field:'TSecretLevel',title:"�����ܼ�",width:100,align:'left',hidden:true},
			{field:'AppTime',title:"ԤԼʱ��",width:35,align:'left',hidden:true},
			{field:'PatientID',title:"PatientID",width:35,align:'left',hidden:true},
			{field:'StatusCode',title:"StatusCode",width:35,align:'left',hidden:true},
			{field:'RBASStatusDesc',title:"�Ű�״̬",width:35,align:'left',hidden:true},
			{field:'RBASStatusCode',title:"�Ű�״̬Code",width:35,align:'left',hidden:true},
			{field:'RBASStatusReason',title:"�Ű���ԭ��",width:35,align:'left',hidden:true},
			{field:'TRDoc',title:"����ҽ��",width:35,align:'left',hidden:true},
			{field:'StatusChangeDate',title:"ԤԼ״̬�������",width:35,align:'left',hidden:true},
			{field:'StatusChangeTime',title:"ԤԼ״̬���ʱ��",width:35,align:'left',hidden:true},
			{field:'StatusChangeUserName',title:"ԤԼ״̬��",width:35,align:'left',hidden:true},
			{field:'SystemSession',title:"�ⲿϵͳ��",width:35,align:'left',hidden:true},
			{field:'AppIntervalTime',title:"ȡ��ʱ��(����)",width:35,align:'left',hidden:true},
			{field:'LineNum',title:"�����",width:35,align:'left',hidden:true},
			{field:'TPoliticalLevel',title:"���˼���",width:35,align:'left',hidden:true},
			{field:'TSecretLevel',title:"�����ܼ�",width:35,align:'left',hidden:true},
			{field:'RowId',title:"ԤԼID",width:150,align:'left'},

				
			 ]] ,
		 onSelect:function (rowIndex, rowData){



		},
		onLoadSuccess:function(rowData){
			
		}




	
});
return tabdatagrid
}

//������������ ------------begin----

//��ʼ������
function IntCalender(){
	//���
	var rbasdr=PageLogicObj.rbasdr;
	var AppMethCodeStr=ServerObj.AppMethCodeStr
	var CanAddApponit=ServerObj.CanAddApponit
	if (PageLogicObj.SelectAppMeth!=""){
		AppMethCodeStr=PageLogicObj.SelectAppMeth
	}
	
	$('#Cancel').bind('click',function(){Cancel()})
	var datastr = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"getcalenderHtml",
		dataType:"text",
		menthdate:PageLogicObj.nowmoth,
		rbasdr:rbasdr,
		CanAddApponit:CanAddApponit,
		AppMethCode:AppMethCodeStr,
		USERID:session['LOGON.USERID'],	
	},false);
	if (datastr!=""){
		var datahtml=datastr.split("^")[0]
		PageLogicObj.nowmoth=datastr.split("^")[1]
	}else{
		var datahtml=""
		PageLogicObj.nowmoth=""
	}
	//
	$('#calender').html(datahtml)
	//�·�����
	$('#upmoth').bind('click',function(){ChangeCalenderDate('up')})
	//�·�����
	$('#downmoth').bind('click',function(){ChangeCalenderDate('down')})
	//��ǰ�·�
	$('#nowmoth').bind('click',function(){ChangeCalenderDate('now')})	
	
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'������ɫ'}
	$("#holidaycolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'�Ǳ�����ɫ'}
	$("#outmethcolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'������ɫ'}
	$("#nowmothcolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'������ɫ'}
	$("#nowdatecolor").popover(PorpStr)
	var PorpStr={trigger:'hover',placement:'top-left',title:'',content:'С�ڵ��յ���Ч����'}
	$("#yesdatecolor").popover(PorpStr)
	PageLogicObj.OldID=""
	
	PageLogicObj.OldColor=""
}
function AddClass(value){
	
	$('#'+value).addClass("selectCls"); //css("background", ServerObj.selectcolor); 
	$('#T'+value).addClass("selectColor"); 
	$('#D'+value).addClass("selectColor"); 
}
//�����������ɫ����

function calendersearce(value){
	//if (PageLogicObj.OldID!=""){$('#'+PageLogicObj.OldID).css("background",PageLogicObj.OldColor);}
	//PageLogicObj.OldID=value;PageLogicObj.OldColor=$('#'+value).css('background-color');
	//$('#'+value).css("background", ServerObj.selectcolor); \
	
	$(".selectCls").removeClass("selectCls");
	$(".selectColor").removeClass("selectColor");
	//�����ѯ
	var htmldate=$cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"DateToHtml",
		dataType:"text",
		date:value
	},false);
	AddClass(value);
	//����ѡ���ʱ���Զ������ѯ
	$('#StartDay').datebox('setValue',htmldate)
	$('#EdDate').datebox('setValue',htmldate)
	LoadtabAppList();
	clearTimeout(PageLogicObj.tabtimer);
	//���ǻ���Ӱ�콻��
	PageLogicObj.tabtimer=window.setTimeout('IntTabload("'+value+'")',1000)
	calendersearceAppoint(value)

}

//ͬ����ѯ����ͬ����ѯ--
function IntTabload(value)
{
	LoadtabAppList()
}


//����ѡ��ԤԼ�� ��һ�¡���һ�¡�����
function ChangeCalenderDate(type){	
	if (PageLogicObj.nowmoth==""){
		$.messager.alert("��ʾ","������ǰ��ʾ���ڲ�����,�����쳣!")
		return
	}
	//---����ʱ��
	var nowmothArry=PageLogicObj.nowmoth.split("-")
	var year=nowmothArry[0]
	var motn=nowmothArry[1]
	var date=nowmothArry[2]
	if (type=='up') motn=parseInt(motn)-1
	if (type=='down') motn=(parseInt(motn)+1)
	if (motn>12){year=(parseInt(year)+1);motn="01"}
	if (motn<1){year=(parseInt(year)-1);motn="12"}
	if (type=='now'){nowmoth=ServerObj.nowDate;;var nowmothArry=nowmoth.split("-");var year=nowmothArry[0];var motn=nowmothArry[1];var date="01"}
	var nowmoth=year+"-"+motn+"-"+date
	PageLogicObj.nowmoth=nowmoth
	IntCalender()
	return
}

//����˫����ԤԼ����
function calendersearceAppoint(date)
{
	//˫����ʱ�򲻴�����ѯ
	clearTimeout(PageLogicObj.tabtimer);
	
	var rbasaobj=$("[id='T"+date+"']")
	var rbasdrstr=""
	for (var i=0;i<rbasaobj.length;i++){
		var onerbas=$(rbasaobj[i]).attr('rbasdr')
		var canApp=$(rbasaobj[i]).attr('canApp')
		if (canApp!="Y"){continue} //�Ƿ����ԤԼ��־
		if ((onerbas=="")||(typeof onerbas =="undefined")){continue}
		if (rbasdrstr==""){rbasdrstr=onerbas}
		else{rbasdrstr=rbasdrstr+"^"+onerbas}
	}
	if (rbasdrstr==""){
		//$.messager.alert("��ʾ","����ѡ����Ч�ļ�¼����ԤԼ!")
		$.messager.popover({msg: '����ѡ����Ч�ļ�¼����ԤԼ!',type:'alert'});
		AppointMentOpen("")
		return
	}
	var IsHoliday = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"IsHolidayDate",
		dataType:"text",
		CurrDate:date,
		},false);
	if (IsHoliday=="1"){
		$.messager.confirm('ȷ�϶Ի���', '����Ϊ�ڼ��գ��Ƿ�ԤԼ?', function(r){
			if (r){
			    AppointMentOpen(rbasdrstr)
			}
		});
	}else{AppointMentOpen(rbasdrstr);}
	
}
//������������ end----

//���ڴ�����
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}

function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
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

//��ԤԼ����
function AppointMentOpen(rbasdrstr)
{
	var patdr=""
	try{
		var frmobj=dhcsys_getmenuform();
		if (frmobj){patdr=frmobj.PatientID.value}
	}catch(e){}
	//lxz ԤԼ��ѡ��ԤԼ��ʽ
	var AppMethCodeStr=ServerObj.AppMethCodeStr
	if (PageLogicObj.SelectAppMeth!=""){
		AppMethCodeStr=PageLogicObj.SelectAppMeth
	}else{
		$.messager.alert("��ʾ","����ѡ��ԤԼ��ʽ!")
		return
	}	
	var awidth=screen.availWidth/6*5; 
	var aheight=screen.availHeight/5*4; 
	console.log(AppMethCodeStr,ServerObj.CanNoCardApp)
	frames[0].LoadPage(rbasdrstr,"",AppMethCodeStr,ServerObj.CanNoCardApp)
	//var src="dhcdoc.appointment.app.hui.csp?RBASRowID="+rbasdrstr+"&AppMethCodeStr="+AppMethCodeStr+"&PatientID="+patdr+"&CanNoCardApp="+ServerObj.CanNoCardApp;
	/*var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("Appoint","ԤԼ", awidth, aheight,"icon-w-edit","",$code,"");	*/
}

//���ڴ򿪺���
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}

function PrintAppInfo()
{
	
	var selectobj=$('#tabApponitmentList').datagrid("getSelections")
	if (selectobj.length<=0){
		$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ��ԤԼ��¼!")
		return
	}
	for (var i=0;i<selectobj.length;i++){
		var oneobj=selectobj[i]
		var AppRowID=oneobj.RowId
		if (AppRowID==""){
			$.messager.alert("��ʾ",oneobj.PatientName+$g("���߲�����ԤԼ��¼ID"))
			continue
		}
		var statucode = $cm({
			ClassName:"web.DHCDocAppointmentHui",
			MethodName:"GetAppStatuCode",
			dataType:"text",
			appid:AppRowID
		},false);

		if (statucode!="I"){
			$.messager.alert("��ʾ",oneobj.PatientName+$g(",ԤԼ��¼״̬�Ƿǡ�ԤԼ��״̬���ܴ�ӡԤԼ����"))
			continue
		}
		PrintAPPMesag(AppRowID)
	}
}

//ԤԼ��ӡ�¼��뷽�� ������ԤԼ�Ĳ�ѯ����һ��
function PrintAPPMesag(AppID)
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	var Rtn = $cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetAppPrintData",
		dataType:"text",
		AppARowid:AppID,
		AppMedthod:ServerObj.AppMethCodeStr,
	},false);
	var RtnArry=Rtn.split("^")
	var PDlime=String.fromCharCode(2);
	var MyPara="CardNo"+PDlime+RtnArry[0]+"^"+"PatNo"+PDlime+RtnArry[13]+"^"+"PatName"+PDlime+RtnArry[2]+"^"+"RegDep"+PDlime+RtnArry[6]
	var MyPara=MyPara+"^"+"SessionType"+PDlime+RtnArry[18]+"^"+"MarkDesc"+PDlime+RtnArry[7]+"^"+"Total"+PDlime+RtnArry[17];
	var MyPara=MyPara+"^"+"AdmDate"+PDlime+RtnArry[10]+"^"+"APPDate"+PDlime+RtnArry[8]+" "+RtnArry[9]+"^"+"SeqNo"+PDlime+RtnArry[4]
	var MyPara=MyPara+"^"+"UserCode"+PDlime+RtnArry[15];
	var MyPara=MyPara+"^"+"MethType"+PDlime+"["+RtnArry[16]+"]"
	var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+RtnArry[14] //�������ʱ��
	var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFun(myobj,MyPara,"")
	DHC_PrintByLodop(getLodop(),MyPara,"","","");
}

//ȡ��ԤԼ
function CancelApp()
{
	var selectobj=$('#tabApponitmentList').datagrid("getSelections")
	if (selectobj.length<=0){
		$.messager.alert("��ʾ","��ѡ����Ҫȡ����ԤԼ��¼!")
		return
	}
	//����Ƿ���Գ���ִ�м�¼
	var AppRowIDCheckFlag=0
	for (var i=0;i<selectobj.length;i++){
		var oneobj=selectobj[i]
		var AppRowID=oneobj.RowId
		var Rtn = $cm({
		ClassName:"web.DHCDocAppointmentHui",
		MethodName:"CheckBeforeCancel",
		dataType:"text",
		AppID:AppRowID,
		LogonUser:session['LOGON.USERID'],
		},false);
		if (Rtn!=""){
			$.messager.alert("��ʾ",$g("����,")+oneobj.PatientName+$g(Rtn))
			AppRowIDCheckFlag=1
		}
	}
	if (AppRowIDCheckFlag==1){
		return;
		}
	$.messager.confirm('ȷ�϶Ի���', '�Ƿ�ȷ��ȡ��ԤԼ?', function(r){
		if (r) {
			for (var i=0;i<selectobj.length;i++){
				var oneobj=selectobj[i]
				var AppRowID=oneobj.RowId
				//ȡ��ԤԼ
				var Rtn = $cm({
					ClassName:"web.DHCRBAppointment",
					MethodName:"CancelAppointment",
					dataType:"text",
					APPTRowId:AppRowID,
					UserRowId:session['LOGON.USERID'],
				},false);
					if (Rtn!=0){
						$.messager.alert("��ʾ","ȡ��ԤԼʧ��!")
						LoadtabAppList();
						return
				}
			}
			$.messager.popover({msg: 'ȡ��ԤԼ�ɹ���',type:'success',timeout: 1000});
			LoadtabAppList();
		}
	})
}

function DocumentOnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if (keyCode==13) {
		/*
		if(SrcObj && SrcObj.id.indexOf("CardNo")>=0){
			CardNoKeydownHandler(e);
			return false;
		}else if(SrcObj && SrcObj.id.indexOf("PatNo")>=0){
			PatNoKeydownHandler(e);
			return false;
		}
		*/
		return false;
	}
	return true;
}

///��ʼ����ѯ���Һ��б�
function IntFindLoc()
{
	
	$('#FindLoc').val(ServerObj.logonlocdesc)
	$("#FindLocRowid").val(session['LOGON.CTLOCID'])
	IntFindRBAS(session['LOGON.CTLOCID'])
	setTimeout(function(){LoadtabAppList()},100)
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content
    });
}
function SetChildPatNo(patno) {
	$("#FindPatInfo").dialog("close");
	frames[0].ClearPatInfo();
	$("#TabMain").contents().find("#PatNo").val(patno);
	frames[0].PatNoSearch();
	//frames[0].LoadPage("",PatientId,"",ServerObj.CanNoCardApp)
}
