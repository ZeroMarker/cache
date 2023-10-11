

//名称	DHCPEAutoSendMessage.hisui.js
//功能	短信查询hisui
//创建	2021.01.20
//创建人  xy

$(function(){
		
	InitCombobox();

	Info();

	InitSendMessageGrid();
	    
     //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });
        
           
     //清屏
	$("#BClear").click(function() {	
		BClear_click();		
        });  
          
        

   $("#RegNo").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});
		
})


function BClear_click()
{
	
	$("#RegNo,#Name").val("");
	$("#StartDate").datebox('setValue',"");
	$("#EndDate").datebox('setValue',"");
	$(".hisui-combobox").combobox('select','');
	Info();
	BFind_click();
}

function Info()
{
	$("#NoSend").combobox('setValue',"2")
}


//查询
function BFind_click(){
	
	
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo
		}, false);
		
			$("#RegNo").val(iRegNo)
		}	
	$("#SendMessageGrid").datagrid('load',{
			ClassName:"web.DHCPE.SendMessage",
			QueryName:"FindMessage",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			NoSend:$("#NoSend").combobox('getValue'),
			LocID:session['LOGON.CTLOCID']
			})
	
}


function InitSendMessageGrid()
{
	$HUI.datagrid("#SendMessageGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SendMessage",
			QueryName:"FindMessage",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#RegNo").val(),
			Name:$("#Name").val(),
			Type:$("#Type").combobox('getValue'),
			NoSend:$("#NoSend").combobox('getValue'),
			LocID:session['LOGON.CTLOCID']
			
		},
	
		columns:[[
	
		    {field:'TID',title:'ReportID',hidden: true},
		    {field:'TRegNo',width:120,title:'登记号'},
			{field:'TName',width:120,title:'姓名'},
			{field:'TSex',width:60,title:'性别'},
			{field:'TBirth',width:120,title:'出生日期'},
			{field:'TTel',width:120,title:'电话'},
			{field:'TContent',width:460,title:'内容'},
			{field:'TSend',width:60,title:'发送',align:'center',
			formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="1") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
			}},
			{field:'TType',width:100,title:'类型'},
			{field:'TSendDate',width:120,title:'发送时间'},
			{field:'TSendStatus',width:80,title:'状态'}
		
			
		]],
		onSelect: function (rowIndex, rowData) {
			  						
		}
		
			
	})
}

function InitCombobox()
{
	 
	
	//类型
	var TypeObj = $HUI.combobox("#Type",{
		valueField:'id',
		textField:'text',
		panelHeight:'200',
		data:[
            {id:'RP',text:$g('报告通知')},
            {id:'HR',text:$g('上报高危')},
            {id:'RR',text:$g('高危结果')},
            {id:'RC',text:$g('高危建议')},
            {id:'FS',text:$g('自由发送')},
            {id:'PAADM',text:$g('复查提醒')},
            {id:'NetPre',text:$g('网上预约')},
            {id:'HisPre',text:$g('His预约')},
            {id:'VC',text:$g('验证码')}
               
        ]

	}); 
	
	
	//发送状态
	var NoSendObj = $HUI.combobox("#NoSend",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'2',text:$g('发送成功')},
            {id:'3',text:$g('发送失败')},
            {id:'0',text:$g('待发送')}
           
        ]

	}); 
		
	
}
