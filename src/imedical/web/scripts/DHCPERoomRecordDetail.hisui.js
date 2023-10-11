
//名称	DHCPERoomRecordDetail.hisui.js
//功能  诊室调整等候名单
//创建	2018.09.19
//创建人  xy


$(function(){

	InitCombobox();

	InitRoomRecordDetailDataGrid();
		
		//刷新
	$("#BReload").click(function() {	
		Reflesh();		
        });
        
        
        //诊室信息调整
	$("#BModifyRoom").click(function() {	
		BModifyRoom_Click();		
        });
			
	//修改
     $("#BModify").click(function() {	
		BModify_click();		
        });
	
})

function InitRoomRecordDetailDataGrid(){
	
	$HUI.datagrid("#dhcperoomrecorddetail",{
		url: $URL,
		fit : true,
		border : false,
		striped : false,//是否显示斑马线效果
		fitColumns : false,
		autoRowHeight : false,
		rownumbers : true, //如果为true, 则显示一个行号列 
		pagination : true, //如果为true, 则在DataGrid控件底部显示分页工具栏 
		pageSize: 10,
		pageList : [10,20,30],
		singleSelect: true,
		selectOnCheck: false,
		autoRowHeight: false,
		queryParams:{
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
			
		},
		frozenColumns:[[
			{field:'TIND',width:'40',title:'序号'},
			{field:'TRegNo',width:'120',title:'登记号'}
		]],
		columns:[[
			{field:'TStatus',title:'状态',hidden:true},
			{field:'TRecordID',title:'RecordID',hidden:true},
			{field:'TName',width:'120',title:'姓名'},
			{field:'TSex',width:'50',title:'性别'},
			{field:'TBirth',width:'100',title:'出生日期'},
			{field:'TTel',width:'100',title:'联系电话'},
			{field:'TRoomList',title:'排队操作',width:'130',
				formatter:function(value,rowData,index){
				if(rowData.TRecordID!=""){
					
					
					if (("undefined"==typeof HISUIStyleCode)||(HISUIStyleCode==null)){
						return "<span style='cursor:pointer;' class='icon-init' title='重新排队' onclick='NewCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
						"<span style='cursor:pointer;' class='icon-cancel' title='取消排队' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					}else{
						if(HISUIStyleCode=="lite") {
							return "<span style='cursor:pointer;' class='icon-init' title='重新排队' onclick='NewCurRoom("+rowData.TRecordID+")'></span>"+
							"<span style='padding-left:10px;cursor:pointer;' class='icon-cancel' title='取消排队' onclick='StopCurRoom("+rowData.TRecordID+")'></span>";
					
						}else{
							return "<span style='cursor:pointer;' class='icon-init' title='重新排队' onclick='NewCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-cancel' title='取消排队' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
						}
					}
					
					
					
					/*
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="重新排队" border="0" onclick="NewCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="取消排队" border="0" onclick="StopCurRoom('+rowData.TRecordID+')"></a>';
					*/
					}
				}},
			{field:'TCallList',title:'叫号操作',width:'150',
				formatter:function(value,rowData,rowIndex){
				if((rowData.TRecordID!="")&&(rowData.TStatus=="N")){
					
					if (("undefined"==typeof HISUIStyleCode)||(HISUIStyleCode==null)){
							return "<span style='cursor:pointer;' class='icon-stamp' title='叫号' onclick='CallCurRoom("+rowIndex+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-pass' title='顺延' onclick='DelayCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-cancel' title='过号' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					
					}else{
						if(HISUIStyleCode=="lite") {
								return "<span style='cursor:pointer;' class='icon-stamp' title='叫号' onclick='CallCurRoom("+rowIndex+")'></span>"+
								"<span style='padding-left:10px;cursor:pointer;' class='icon-stamp-pass' title='顺延' onclick='DelayCurRoom("+rowData.TRecordID+")'></span>"+
								"<span style='padding-left:10px;cursor:pointer;' class='icon-stamp-cancel' title='过号' onclick='StopCurRoom("+rowData.TRecordID+")'></span>";
					
						}else{
							return "<span style='cursor:pointer;' class='icon-stamp' title='叫号' onclick='CallCurRoom("+rowIndex+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-pass' title='顺延' onclick='DelayCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;"+
							"<span style='cursor:pointer;' class='icon-stamp-cancel' title='过号' onclick='StopCurRoom("+rowData.TRecordID+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					
					
						}
					}
					
					
					
					
				
					/*
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="叫号" border="0" onclick="CallCurRoom('+rowIndex+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="顺延" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="过号" border="0" onclick="PassCurRoom('+rowData.TRecordID+')"></a>'
					
					;
					*/
			
				}
				if((rowData.TRecordID!="")&&(rowData.TStatus=="P")){
					
					return '<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png" title="叫号" border="0" onclick="CallCurRoom('+rowIndex+')"></a>\
					<a><img style="padding:0 10px 0px 0px" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_cancel.png" title="顺延" border="0" onclick="DelayCurRoom('+rowData.TRecordID+')"></a>\
					<a><img style="cursor:pointer" src="../scripts_lib/hisui-0.1.0/dist/css/icons/stamp_pass.png" title="过号启用" border="0" onclick="RePassCurRoom('+rowData.TRecordID+')"></a>'
					
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
	
	$.messager.confirm("操作提示", "是否确认重新排队", function (data) {
            		if (data) {
	          
	             		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReSetCurRoomInfoNew",ID);
						var Arr=rtn.split("^");
	
						if (Arr[0]!="0"){
								$.messager.alert('提示',Arr[1],"info");
						}else if (Arr[0]=="0"){
								$.messager.alert('提示',Arr[1],"info");
						}
						Reflesh();

	        		}
            		else {
	            		return false;	
                		
            		}
        	});	


}
//取消排队
function StopCurRoom(RecordID)
{
	var ID=RecordID;
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	
	
	$.messager.confirm("操作提示", "是否确认取消排队", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","StopCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
					$.messager.alert('提示',Arr[1],"info");
			}else if (Arr[0]=="0"){
					$.messager.alert('提示',Arr[1],"info");
			}
			Reflesh();
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
				opener.parent.vRoomRecordID="";
			
				}
			}

	      }else {
		      return false;	
      	}
     })	
        	
	
}


//叫号  调用接口  ARR_StatusDetail更新为C
function CallCurRoom(rowIndex)
{
	var rows=$("#dhcperoomrecorddetail").datagrid('getRows');
	var rowData = rows[rowIndex];
	var Status=rowData.TStatus;
	var RegNo=rowData.TRegNo;
	var RecordID=rowData.TRecordID;
	
	
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
	
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
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
	
   var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",ID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		$.messager.alert('提示',Arr[1],"info");
	}else if (Arr[0]=="0"){
		$.messager.alert('提示',Arr[1],"info");
	
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


//过号启用
function RePassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能过号启用","info");
		return false;
	}
	$.messager.confirm("操作提示", "是否确认过号启用", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
				$.messager.alert('提示',Arr[1],"info");
			}else if (Arr[0]=="0"){
				$.messager.alert('提示',Arr[1],"info");
			}
			Reflesh();
	
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
					opener.parent.vRoomRecordID="";
		
				}
			}

	      }else {
		      return false;	
      	}
     })	
}

//过号  设置为过号状态
function PassCurRoom(RecordID)
{
	var ID=RecordID;
	
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能过号","info");
		return false;
	}
	
	$.messager.confirm("操作提示", "是否确认过号", function (data) {
    	if (data) {
	          
	    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",ID);
			var Arr=rtn.split("^");
			if (Arr[0]!="0"){
				$.messager.alert('提示',Arr[1],"info");
			}else if (Arr[0]=="0"){
				$.messager.alert('提示',Arr[1],"info");
			}
			Reflesh();
	
			if (opener){
				if (opener.document.getElementById("SpecNo"))
				{
					opener.vRoomRecordID="";
				}else{
					opener.parent.vRoomRecordID="";
		
				}
			}

	      }else {
		      return false;	
      	}
     })	
	
    
}

function Reflesh(){
	$("#dhcperoomrecorddetail").datagrid('load', {
			ClassName:"web.DHCPE.RoomManager",
			QueryName:"FindRoomPersonDetail", 
			RoomID:RoomID,
		
	});

}
/*
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
*/
function InitCombobox(){

	 //性别   
	var SexObj = $HUI.combobox("#Sex",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'N',text:'不限'},
            {id:'M',text:'男'},
            {id:'F',text:'女'},
           
        ]

	});
	
	
}


//诊室信息调整
function BModifyRoom_Click()
{
	
 
  $("#RoomModifyWin").show();
  
   $HUI.window("#RoomModifyWin", {
        title: "诊室信息调整",
        iconCls: "icon-w-edit",
        collapsible: false,
        minimizable: false,
        maximizable: false,
        modal: true,
        width: 240,
        height: 256,
       
    });
    
    var ret=tkMakeServerCall("web.DHCPE.RoomManager","GetOneRoomInfo",RoomID);
 	 var sex=ret.split("^")[3];
  	var Minute=ret.split("^")[12];
  	var ActiveFlag=ret.split("^")[15];
    $("#RoomDesc").val(RoomDesc);
    $("#Sex").combobox('setValue',sex); 
    $("#RMinute").val(Minute);
    if(ActiveFlag=="Y"){
    	$("#RActiveFlag").checkbox('setValue',true);
    }else{
	    $("#RActiveFlag").checkbox('setValue',false);
    }
	
}

//修改
function BModify_click(){
	
	var RMinute=$("#RMinute").val();
	var Sex=$("#Sex").combobox('getValue');
	var RActiveFlag="Y";
	var RActiveFlag=$("#RActiveFlag").checkbox('getValue');
	if(RActiveFlag) {RActiveFlag="Y";}
	var Str=Sex+"^"+RMinute+"^"+RActiveFlag;
	//alert(Str)
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ModifyRoom",RoomID,Str);
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","更新失败"+rtn.split("^")[1],"error");
	}else{
		$.messager.alert("提示","更新成功","success");
		$('#RoomModifyWin').window('close'); 
	}
}