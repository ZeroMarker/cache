//名称	DHCPERoomRecordDetail.hisui.js
//功能  诊室调整等候名单
//创建	2018.09.19
//创建人  xy

var Height="470"
$(function(){
	
	//分辨率
    var userAgent = navigator.userAgent;
	var isChrome =  navigator.userAgent.indexOf('Chrome') > -1
	
	if(isChrome){
     	if((screen.width=="1440")&&(screen.height=="900"))
     	{
	     	Height="610";
     	}
	}else{
		if((screen.width=="1440")&&(screen.height=="900"))
     	{
	     	Height="565";
     	}
	}



		InitRoomRecordDetailDataGrid();
	
})


function InitRoomRecordDetailDataGrid(){
	
	$HUI.datagrid("#dhcperoomrecorddetail",{
		height:Height,
		striped: true, //是否显示斑马线效果
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		showFooter: true,
		nowrap:false,
		url: $URL,
		loadMsg: 'Loading...',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		pageSize: 10,
		pageList: [10, 20, 40, 40],
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
			
		},
		toolbar:[{
		id:"BReload",
		text: '刷新',
		iconCls: 'icon-reload',
		handler: function(){Reflesh();}
		},{
		id:"BModifyRoom",
		text: '诊室信息调整',
		iconCls: 'icon-edit',
		handler: function(){BModifyRoom_Click();}
		}],
		columns:[[
			{field:'TIND',width:'60',title:'序号'},
			{field:'TRegNo',width:'120',title:'登记号'},
			{field:'TName',width:'120',title:'姓名'},
			{field:'TSex',width:'60',title:'性别'},
			{field:'TBirth',width:'120',title:'出生日期'},
			{field:'TTel',width:'120',title:'联系电话'},
			{field:'TRecordID',title:'排队操作',width:'180',
			formatter:function(value,row,index){
				if(value!=""){
			
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="重新排队" border="0" onclick="NewCurRoom('+value+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="取消排队" border="0" onclick="StopCurRoom('+value+')"></a>';
			
					}
				}},
			{field:'TStatus',title:'叫号操作',width:'180',
			formatter:function(value,rowData,rowIndex){
				if(value!=""){
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="叫号" border="0" onclick="CallCurRoom('+rowData.TRecordID+"^"+rowData.TStatus+"^"+rowData.TRegNo+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="顺延" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="过号" border="0" onclick="PassCurRoom('+rowData.TRecordID+')"></a>'
					
					;
			
				}
				}}
		]]
		
		
	
	})
}

//重新排队
function NewCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"ReSetCurRoomInfoNew",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");

		//alert(Arr[1]);
	}
	window.location.reload();
	
	
}
//取消排队
function StopCurRoom(RecordID)
{
	var ID=RecordID;
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"StopCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
	
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}
	window.location.reload();
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
		
		}else{
			opener.parent.vRoomRecordID="";
			
		}
	}
}


//叫号  调用接口  ARR_StatusDetail更新为C
function CallCurRoom(ID)
{
	var Arr=ID.split("^");
	var Status=Arr[1];
	var RegNo=Arr[2];
	var RecordID=Arr[0];
	if (RecordID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	 
	if (opener){
		var OldRecord="";
		if (opener.document.getElementById("SpecNo"))
		{
			OldRecord=opener.vRoomRecordID;
			
			//opener.websys_setfocus("SpecNo");
		}else{
			OldRecord=opener.parent.vRoomRecordID;
			//opener.websys_setfocus("RegNo");
		}
		if ((OldRecord!=RecordID)&&(OldRecord!=""))
		{
			if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
				return false;
			}
		}
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"CallCurRoom",
			"CurRoomID":RecordID

		}, false);
		var Arr=rtn.split("^");
	
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}
	
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID=RecordID;
			opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID=RecordID;
			opener.websys_setfocus("RegNo");
		}
	}
	//调用叫号接口
}

//顺延  三位
function DelayCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"DelayCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			
		}else{
			opener.parent.vRoomRecordID="";
			
		}
	}
}

//过号  设置为过号状态
function PassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	var rtn=$.m({
			"ClassName":"web.DHCPE.RoomManager",
			"MethodName":"PassCurRoomInfo",
			"CurRoomID":ID

		}, false);
	
    // alert(rtn)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
		//alert(Arr[1]);
	}
	window.location.reload();
	
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			
		}else{
			opener.parent.vRoomRecordID="";
		
		}
	}
}

function Reflesh(){
	window.location.reload();
	
}

function BModifyRoom_Click()
{

	var str = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomModify&RoomID="+RoomID;
	var wwidth=400;
	var wheight=220;

	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	var cwin=window.open(str,"_blank",nwin) 
	
}