///Creator:qqa
///CreatDate:2019-04-18

$(function(){
	
	initParams();  
	
	initPage();
	
	initTable();
})

function initParams(){
	CstID = getParam("ID");              /// 会诊ID
}

function initPage(){
	if(SingnIn!=1){
		$('#mainLayout').layout('hidden','north');	
	}	
}

function initTable(){
	/// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
    ///  定义columns
	var columns=[[
		{field:'PrvTpID',title:'职称ID',width:100,hidden:true},
		{field:'PrvTp',title:'职称',width:100,hidden:true},
		{field:'HosID',title:'HosID',width:100,hidden:true},
		{field:'HosType',title:'院内院外',width:110},
		{field:'LocID',title:'科室ID',width:100,hidden:true},
		{field:'LocDesc',title:'科室',width:100},
		{field:'MarID',title:'亚专业ID',width:100,hidden:true},
		{field:'MarDesc',title:'亚专业',width:100,hidden:true},
		{field:'UserID',title:'医生ID',width:110,hidden:true},
		{field:'UserName',title:'医生',width:120},
		{field:'UserPas',title:'密码',width:100,formatter:setInput},
		{field:'Op',title:"操作",width:100,align:'center',formatter:setConIn}
	]];
  
	$HUI.datagrid('#docListTable',{
		url: $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsonQryConsult&ID="+CstID,
		fit:true,
		border:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		headerCls:"panel-header-gray",
		pageSize:60,  
		pageList:[60], 
		loadMsg: '正在加载信息...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		title:'', 
		iconCls:'icon-paper',
		headerCls:'panel-header-gray', //ed
		queryParams:{
			
		},
		onDblClickRow:function(index,row){
			
		},
		onLoadSuccess:function(data){
			showQRCodeConIn(data.rows);
		}
    })			
}

function showQRCodeConIn(datas){
	$("#QRCodeConInDiv").html("");

	for(i in datas){
		addQRCode(datas[i].UserName);
	}
	return;
}

function addQRCode(name){
	if(name=="") return;
	var html="";
	html+='<div class="imgDivItm">';
	html+=	'<div class="imgItm">';
	html+=		'<img class="imgView" style="width:150px;height:150px" src="../scripts/dhcnewpro/images/Nurse_implementPrint.png"/>';
	html+=	'</div>';
	html+=	'<div class="imgDocName">'+name+'</div>';
	html+='</div>';
	$("#QRCodeConInDiv").append(html);
	return;
}

/// 链接
function setInput(value, rowData, rowIndex){
	var isConssignIn = rowData.IsConssignIn;
	var html = "";
	if(isConssignIn!=1){
		html = "<input type='password' index="+rowIndex+" class='hisui-validatebox validatebox-text' />";
	}else{
		html = "***"
	}
	return html;
}


function setConIn(value, rowData, rowIndex){
	var html = "";
	var cstItmID = rowData.itmID;  //这个UserID是CareProvID
	var isConssignIn = rowData.IsConssignIn;
	if(isConssignIn!=1){
		 html = "<a href='javascript:void(0)' onclick='conssignIn(\""+cstItmID+"\","+rowIndex+")'>签到</a>";
	}else{
		html = "√"
	}
	return html;
}

function conssignIn(cstItmID,rowIndex){
	var password = $("input[index="+rowIndex+"]").val();
	if(password==""){
		$.messager.alert("提示","密码不能为空!");
		return;	
	}
	runClassMethod("web.DHCMDTConssignIn","UserConssignIn",{"CstItmID":cstItmID,"Password":password},function(ret){
		if(ret==0) {
			$.messager.alert("提示","签到成功！");
			$HUI.datagrid('#docListTable').load({
				ID:CstID
			})
			return;	
		}
		if(ret!=0){
			if(ret==-1){
				$.messager.alert("提示","密码不正确!");
			}else if(ret==-2){
				$.messager.alert("提示","没有医生信息，无法签到！");
			}else if(ret==-3){
				$.messager.alert("提示","密码格式错误！");
			}else if(ret==-99){
				$.messager.alert("提示","非发送状态不予许签到！");
			}else{
				$.messager.alert("提示","插入日志错误！");
			}
			
			return;	
		}
	},'text')
}


function signIn(){

	$HUI.window("#signInWin").open();
}