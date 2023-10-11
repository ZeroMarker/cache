
//名称	DHCPENotice.hisui.js
//功能	体检到期提醒查询
//创建	2021.07.27
//创建人  sunxintao

$(function(){
			
	InitCombobox();
	
	InitCheckProgressGrid();  
     
    //查询
	$("#BFind").click(function() {	
		BFind_click();		
        });  
})

//查询
function BFind_click(){
	
	$("#NoticeGrid").datagrid('load',{
		ClassName:"web.DHCPE.Notice",
		QueryName:"Notice",
		NoticeType:getValueById("NoticeType"),
		Days:getValueById("Days"),
		Limits:getValueById("Limits")
	});
}




function InitCheckProgressGrid(){
	
		$HUI.datagrid("#NoticeGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Notice",
			QueryName:"Notice",

		},
		columns:[[
			
			{field:'TRegNo',width:250,title:'登记号'},
			{field:'TName',width:250,title:'姓名'},
			{field:'PAPMISex',width:250,title:'性别'},
			{field:'TAge',width:250,title:'年龄'},
			{field:'DateDesc',width:250,title:'到达日期'},
			{field:'GADMDRName',width:250,title:'团体'}
		
		]]
			
	})	
}



function InitCombobox(){
	
	//查询类型
	var Typeobj = $HUI.combobox("#NoticeType",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'1',text:$g('到达N天未总检')},
            {id:'2',text:$g('报告打印N天未领取')},
            {id:'3',text:$g('到达N天未分配总检大夫')}

        ]

	});
	
	//查询范围
	var Limitsobj = $HUI.combobox("#NoticeLimits",{
		valueField:'id',
		textField:'text',
		panelHeight:'130',
		data:[
            {id:'0',text:$g('全部')},
            {id:'1',text:$g('1年内')}

        ]

	});
	
}