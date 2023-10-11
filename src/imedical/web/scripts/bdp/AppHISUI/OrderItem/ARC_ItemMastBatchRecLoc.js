 /**
 * @Author: 钟荣枫 DHC-BDP
 * @Description: 用于接收科室生成页面。
 * @Created on 2019-9

 */
 var init=function(){
 	
 	var addurl="dhc.bdp.ct.arcitemmastrecloc.csp"
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=AddReceiveLoc";

 	var windowHight = document.documentElement.clientHeight;		//可获取到高度
 	var windowWidth = document.documentElement.clientWidth;
 	$(document).ready(function () {
        $("body")[0].onkeydown = keyPress;
        $("body")[0].onkeyup = keyRelease;
    });
      	
    //$('#ItemHospital').combobox("select",defaultHosp)
    window.onload=function(){
    	var data=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",session['LOGON.HOSPID'])
	    var data = eval('(' + data + ')');
	    var defaultHosp=data.list[0].HOSPDefaultHospitalDR  
		$('#ItemHospital').combobox("setValue",defaultHosp)
		$('#LocHospital').combobox("setValue",defaultHosp) 
		ReloadMastCat()	
		SearchItemMast();
		ReloadLocGroup()
		SearchLoc();

	}
    //LOGON.HOSPID
    var KEY = { SHIFT: 16, CTRL: 17, ALT: 18, DOWN: 40, RIGHT: 39, UP: 38, LEFT: 37 };
    var selectIndexs = { firstSelectRowIndex: 0, lastSelectRowIndex: 0 };
    var inputFlags = { isShiftDown: false, isCtrlDown: false, isAltDown: false };
    var grid=""

    function keyPress(event) {//响应键盘按下事件
    	if (grid="")
    	{
    		return
    	}
    	else
    	{
    		var e = event || window.event;
	        var code = e.keyCode | e.which | e.charCode;
	        switch (code) {
	            case KEY.SHIFT:
	                inputFlags.isShiftDown = true;
	                $('#'+grid).datagrid('options').singleSelect = false;
	                break;
	            case KEY.CTRL:
	                inputFlags.isCtrlDown = true;
	                $('#'+grid).datagrid('options').singleSelect = false;
	                break;
	            default:
	        }
    	}
	        
    }

    function keyRelease(event) { //响应键盘按键放开的事件
    	if (grid="")
    	{
    		return
    	}
    	else
    	{
    		var e = event || window.event;
	        var code = e.keyCode | e.which | e.charCode;
	        switch (code) {
	            case KEY.SHIFT:
	                inputFlags.isShiftDown = false;
	                selectIndexs.firstSelectRowIndex = 0;
	                $('#'+grid).datagrid('options').singleSelect = true;
	                break;
	            case KEY.CTRL:
	                inputFlags.isCtrlDown = false;
	                selectIndexs.firstSelectRowIndex = 0;
	                $('#'+grid).datagrid('options').singleSelect = true;
	                break;
	            default:
	        }
    	}
	        
    }

	//医嘱项表格内 医院下拉框
	$('#ItemHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=ARC_ItemMast",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			SearchItemMast();
			ReloadMastCat()
		}
	});

	//重载医嘱子类
	ReloadMastCat=function(){
		var MastHosp=$('#ItemHospital').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.ARCItemCat&QueryName=GetDataForCmb1&ResultSetType=array&hospid=" +MastHosp;
      	$('#OrderCatDR').combobox('reload',url);
	}

	$('#OrderCatDR').combobox({ 
		valueField:'ARCICRowId',
		textField:'ARCICDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			SearchItemMast();
		}
	});
	
	//医嘱项描述查找

	$('#ItemMastDesc').searchbox({
		width: (windowWidth-158)*0.27*0.5,
		searcher:function(value,name){
			SearchItemMast();
		}
	});
	//刷新
	$("#btnItemMastRefresh").click(function (e) {
		var data=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",session['LOGON.HOSPID'])
	    var data = eval('(' + data + ')');
		var defaultHosp=data.list[0].HOSPDefaultHospitalDR  	//重置为登录医院
		$('#ItemHospital').combobox("setValue",defaultHosp) 
		$('#OrderCatDR').combobox("reload") 
		$('#OrderCatDR').combobox("setValue","") 
		//$('#ItemHospital').combobox('setValue','');		
		$("#ItemMastDesc").searchbox('setValue', '');
		SearchItemMast();
	 }) 
 	//查找医嘱项
 	SearchItemMast=function(){
 		$('#itemmastgrid').datagrid('clearSelections');		//清除选中
		var ItemMastDesc=$.trim($("#ItemMastDesc").searchbox('getValue'));
		var Hospital=$('#ItemHospital').combobox('getValue');
		var ordercat=$("#OrderCatDR").combobox("getValue")
		var options={};
        options.url=$URL;
        options.queryParams={
                ClassName: "web.DHCBL.CT.ARCItmMast",
                QueryName: "GetDataForCmb1",
                'desc':ItemMastDesc,
				'hospid':Hospital,
				'subcat':ordercat
        } 
        
		$('#itemmastgrid').datagrid(options);
 		/*$('#itemmastgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.CT.ARCItmMast",
				'QueryName':"GetDataForCmb1",
				'desc':ItemMastDesc,
				'hospid':Hospital
		});	*/
			
 	}
 	

	//医嘱项
	var itemmastgrid=$HUI.datagrid('#itemmastgrid',{
		/*url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.ARCItemMast",
			QueryName:"GetList"

		},*/
		columns:[[								
				{field:'ARCIMRowId',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'ARCIMDesc',title:'描述',width:80,sortable:true}
												
				]],	
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.4-8-50)*0.7,		
		idField:'ARCIMRowId',
		loadMsg:'',
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        showRefresh:false,
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],	
		//selectOnCheck:true,
		singleSelect:false, //只允许选中一行
		//ctrlSelect:true,
		remoteSort:false,    
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		toolbar: "#itemmastbar",
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        },
        onClickRow:function(index,row){
        	grid="itemmastgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#itemmastgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#itemmastgrid').datagrid('selectRow', i);
	            }
	        }
        }

	});		


	//被选中的医嘱项 selecteditemmastgrid
	var selecteditemmastgrid=$HUI.datagrid('#selecteditemmastgrid',{
				
		columns:[[	
				{field:'Id',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'Data',title:'描述',width:80,sortable:true}
				]],		
		pageSize:20,
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.4-8-50)*0.3,		
		singleSelect:false,
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		idField:'Id',		
		fitColumns:true,
		toolbar: [] ,
        onClickRow:function(index,row){
        	grid="selecteditemmastgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#selecteditemmastgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#selecteditemmastgrid').datagrid('selectRow', i);
	            }
	        }
        }
	});	

	//科室表格内 医院下拉框
	$('#LocHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			ReloadLocGroup()
			SearchLoc();
		}
	});
	ReloadLocGroup=function(){
		$('#LocGroup').combobox('setValue','');
		var LocHospital=$('#LocHospital').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.RBCDepartmentGroup&QueryName=GetDataForCmb1&ResultSetType=array&hospid=" +LocHospital;
      	$('#LocGroup').combobox('reload',url);

	}
	//科室组 
	$('#LocGroup').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.RBCDepartmentGroup&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'DEPRowId',
		textField:'DEPDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			SearchLoc();
		}
	});
	//科室描述查找
	
	$('#LocDesc').searchbox({
		width: (windowWidth-158)*0.27*0.5,
		searcher:function(value,name){			
			SearchLoc();
		}
	});
	//刷新
	$("#btnLocRefresh").click(function (e) { 
		var data=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",session['LOGON.HOSPID'])
	    var data = eval('(' + data + ')');
	    var defaultHosp=data.list[0].HOSPDefaultHospitalDR  
		$('#LocHospital').combobox("setValue",defaultHosp) 
		//$('#LocHospital').combobox('setValue','');
		/*$('#LocGroup').combobox({
			data:  [],
			url:""
		});*/
		$('#LocGroup').combobox('reload');
		$('#LocGroup').combobox('setValue','');
		$("#LocDesc").searchbox('setValue', '');
		
		SearchLoc();
	 }) 
	//查找科室	
	SearchLoc=function(){
		$('#locgrid').datagrid('clearSelections');		//清除选中
		
		var LocGroup=$('#LocGroup').combobox('getValue');
		
		var LocHospital=$('#LocHospital').combobox('getValue');
		var LocDesc=$.trim($("#LocDesc").searchbox('getValue'));
		$('#locgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.CT.CTLoc",
				'QueryName':"GetList",
				'dep': LocGroup,
				'hospid':LocHospital,
				'desc':	LocDesc	,
				'activeflag':"Y"						
		});
	}	 	
	
	//科室 
	var locgrid=$HUI.datagrid('#locgrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.CTLoc",
			QueryName:"GetList",
			activeflag:"Y"
		},
		columns:[[	
				{field:'CTLOCRowID',title:'ID',width:40,sortable:true,hidden:true}, //
				{field:'CTLOCDesc',title:'描述',width:80,sortable:true},
				{field:'HospitalGroupDR',title:'所属医院',width:80,sortable:true,hidden:true}
				
				]],		
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.5,			
		idField:'CTLOCRowID',		
		loadMsg:'',
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        showRefresh:false,
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],	
		selectOnCheck:true,
		remoteSort:false,    
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		toolbar: "#locbar",
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        },
        onClickRow:function(index,row){
        	grid="locgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#locgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#locgrid').datagrid('selectRow', i);
	            }
	        }
        }

	});	
			
	//病人科室patlocgrid
	var patlocgrid=$HUI.datagrid('#patlocgrid',{
		columns:[[	
				{field:'Id',title:'ID',width:40,sortable:true,hidden:true}, //,hidden:true
				{field:'Data',title:'描述',width:80,sortable:true},
				{field:'Hospital',title:'所属医院',width:80,hidden:true}
				]],		
		pageSize:20,
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.25,
		singleSelect:false,
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,	
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		fitColumns:true, 
		idField:'Id',
		toolbar: [] ,
        onClickRow:function(index,row){
        	grid="patlocgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#patlocgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#patlocgrid').datagrid('selectRow', i);
	            }
	        }
        }
	});	

	//接收科室ordlocgrid
	var reclocgrid=$HUI.datagrid('#reclocgrid',{
		
		columns:[[	
				{field:'Id',title:'ID',width:40,sortable:true,hidden:true},  //,hidden:true
				{field:'Data',title:'描述',width:80,sortable:true},
				{field:'Hospital',title:'所属医院',width:80,sortable:true,hidden:true}
				]],		
		pageSize:20,
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.25,
		singleSelect:false,
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		fitColumns:true, 
		idField:'Id',
		toolbar: [] ,
        onClickRow:function(index,row){
        	grid="reclocgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#reclocgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#reclocgrid').datagrid('selectRow', i);
	            }
	        }
        }
	});	


	//医院下拉框
	$('#ARCRLCTHospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
	});

	//就诊类型   就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
	$('#ARCRLClinicType').combobox({ 
		data:[
			{id:'O',text:'门诊'},{id:'E',text:'急诊'},{id:'I',text:'住院'}
			,{id:'H',text:'体检'},{id:'N',text:'新生儿'}
		],
		valueField:'id',
		textField:'text'
		
	});

	
	
	var createcol =[[  
				  {field:'ItemMast',title:'医嘱项',width:200,sortable:true},
				  {field:'PatLoc',title:'病人科室',width:100,sortable:true},
				  {field:'RecLoc',title:'接收科室',width:100,sortable:true},
				  {field:'SameHosp',title:'是否同一医院组',width:150,sortable:true},

				  {field:'RLDefaultFlag',title:'默认',width:60,sortable:true,formatter:ReturnFlagIcon},
				  {field:'TItemMastId',title:'TItemMastId',width:80,sortable:true,hidden:true},
				  {field:'TPatLocId',title:'TPatLocId',width:80,sortable:true,hidden:true},
				  {field:'TRecLocId',title:'TRecLocId',width:80,sortable:true,hidden:true},
				  {field:'RLDateFrom',title:'开始日期',width:100,sortable:true},
				  {field:'RLDateTo',title:'结束日期',width:100,sortable:true},
				  {field:'RLTimeFrom',title:'开始时间',width:100,sortable:true},
				  {field:'RLTimeTo',title:'结束时间',width:100,sortable:true},
				  {field:'RLCTHospitalDR',title:'医院',width:200,sortable:true},
				  {field:'RLOrderPriorityDR',title:'医嘱优先级',width:100,sortable:true},
				  {field:'RLFunction',title:'功能',width:200,sortable:true},				  
				  {field:'RLClinicType',title:'就诊类型',width:200,sortable:true}

	 ]];
	 var resultcol =[[  
				  {field:'Data',title:'原始数据',width:200,sortable:true},
				  {field:'Tips',title:'提示',width:250,sortable:true}				  			
	 ]];
	 
	 //生成数据预览表
	var creategrid = $HUI.datagrid("#creategrid",{
		
		idField:'RowId',
		columns: createcol, 
		//pagination: true,  

		//pageSize:20,
		//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    
		fixRowNumber:true,
		//fitColumns:true, 
		remoteSort:false,  		       
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }
	});
	 //数据检测表
	var resultgrid = $HUI.datagrid("#resultgrid",{	
		idField:'RowId',
		columns: resultcol,  
		//pagination: true,   
		//pageSize:20,
		//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    
		fixRowNumber:true,
		fitColumns:true, 
		remoteSort:false, 				       
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  
        	$(this).datagrid('columnMoving'); 
        }
	});
	//添加医嘱项 addItemMast
	$("#addItemMast").click(function(e) {		
		AddFunlib("itemmastgrid","selecteditemmastgrid");
	});
	//添加病人科室按钮 addPatLoc
	$("#addPatLoc").click(function(e) {
		AddFunlib("locgrid","patlocgrid");
	});
	//添加接收科室按钮 addRecLoc
	$("#addRecLoc").click(function(e) {
		AddFunlib("locgrid","reclocgrid");
	});
	//删除医嘱项 delItemMast
	$("#delItemMast").click(function(e) {		
		DeleteFunlib("selecteditemmastgrid");
	});
	//删除病人科室按钮 delPatLoc
	$("#delPatLoc").click(function(e) {
		DeleteFunlib("patlocgrid");
	});
	//删除接收科室按钮 delRecLoc
	$("#delRecLoc").click(function(e) {
		DeleteFunlib("reclocgrid");
	});
	//添加
	AddFunlib=function(from,to) {				
		var datas = $('#'+from).datagrid('getSelections');	 //获取所有选中的行
		
		if(datas==""){
			$.messager.alert('提示',"未选中要添加的行!","info");						
			return false;
		}
		if(datas.length>0)
		{
			//w ##class(web.DHCBL.CT.CTHospital).OpenData(52)
			for(var i=0;i<datas.length;i++)
			{	
				var data="";
				var id="";
				var Hospital=""
				
				switch(from)
				{
					case "itemmastgrid": data=datas[i].ARCIMDesc
					id=datas[i].ARCIMRowId	
					
					break;
					
					case "locgrid":	data=datas[i].CTLOCDesc
					id=datas[i].CTLOCRowID
					Hospital=datas[i].HospitalGroupDR								
					break;
				 }

				 
				var rows = $("#"+to).datagrid("getRows"); //获取当前页的所有行。
				var flag=1;
				for(var j=0;j<rows.length;j++)			//判断重复
				{
					if(id==rows[j].Id){
						flag=0;
						break;
					}	
				}
				if(flag==1){
					if(from=="itemmastgrid"){
						$('#'+to).datagrid('appendRow',{			
							Data: data,
							Id:id,
							Hospital:Hospital
						})
					}else{
						$('#'+to).datagrid('appendRow',{			
							Data: data,
							Id:id,
							Hospital:Hospital
						})
					}
					
				}else{
					continue;
				}
			}		
		}		
	}
	//生成
	$("#btnCreat").click(function(e) {
		var move=AddToList();
		if(move){
			$("#WinCreate").show();
			var WinCreate = $HUI.dialog("#WinCreate",{
				iconCls:'icon-w-list',
				resizable:true,
				width: windowWidth-50,
				height: windowHight-20,     
				title:'生成预览',
				modal:true,
				buttonAlign : 'center',
				buttons:[{
					text:'校验',
					//iconCls:'icon-w-eye',
					//id:'btnSearchLog',
					handler:function(){					
						Check();								
					}
				},{
					text:'导入',
					//iconCls:'icon-w-save',
					handler:function(){
						SaveFunLib();	
						$("#WinResult").show();
						var WinResult = $HUI.dialog("#WinResult",{	
							iconCls:'icon-w-list',		
							resizable:true,
							title:'导入结果',
							width: windowWidth-250,    
   							height: windowHight-50,
							modal:true,
							buttonAlign : 'center',
							buttons:[{
								text:'关闭',
								//iconCls:'icon-cancel',
								handler:function(){
									WinResult.close();
								}
							}]					
						});	
					}
				},{
					text:'取消',
					//iconCls:'icon-cancel',
					handler:function(){
						WinCreate.close();
					}
				}]
			});	
		}
	});	
	//手工维护
	$("#btnAdd").click(function(e) {
		$("#AddByHands").show();
		
		var myWin = $HUI.dialog("#AddByHands",{			
			resizable:true,
			iconCls:'icon-w-setting',
			title:'手工维护',
			width: windowWidth-50,    
   			height: windowHight-20,
			buttonAlign : 'center',
			modal:true,
			draggable :true,
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' iconCls='icon-w-home' src='"+addurl+"'></iframe>"
		});
	
		//icon-DP
		//document.getElementById("addhtml").innerHTML="<iframe scrolling='auto' frameborder='0' width='100%' height='100%' iconCls='icon-w-home' src='"+addurl+"'></iframe>";
	});	
	

	//重置
	$("#btnClear").click(function(e) {
		//selecteditemmastgrid patlocgrid reclocgrid
		$('#itemmastgrid').datagrid('clearSelections');
		//$('#ordercatgrid').datagrid('clearSelections');
		$('#locgrid').datagrid('clearSelections');		
		//$('#locgroupgrid').datagrid('clearSelections');
		$('#selecteditemmastgrid').datagrid('loadData', { total: 0, rows: [] });			
		$('#patlocgrid').datagrid('loadData', { total: 0, rows: [] });	
		$('#reclocgrid').datagrid('loadData', { total: 0, rows: [] });
		
		$("#ItemMastDesc").searchbox('setValue', '');		//置空医嘱项描述
		
		$('#LocGroup').combobox('setValue',"");	//置空科室组
		$('#ARCRLCTHospitalDR').combobox('setValue',"");	//置空医院
		$("#LocDesc").searchbox('setValue', '');			//置空科室描述
		$('#ARCRLOrderPriorityDR').combobox('setValue',"");	//置空医嘱优先级
		$('#ARCRLFunction').combobox('setValue',"");	//置空功能
		$('#ARCRLClinicType').combobox('setValues',[]);	
		

		//$('#ARCRLDateFrom').datebox('setValue', "");
		$('#ARCRLDateFrom').datebox('setValue', getCurentDateStr());	
		$('#ARCRLDateTo').datebox('setValue', "");	
		$('#ARCRLTimeFrom').timespinner('setValue',"");			
		$('#ARCRLTimeTo').timespinner('setValue',"");	
		$HUI.checkbox("#ARCRLDefaultFlag").setValue(false);
		$HUI.radio("#OneToOne").setValue(true);
		$HUI.radio("#ManyToMany").setValue(false);
		//$('#itemmastgrid').datagrid('reload');
	
		//$('#locgrid').datagrid('reload');
		SearchItemMast()
		SearchLoc()
	});
	//删除一行/多行
	DeleteFunlib=function(from) {

		var datas = $('#'+from).datagrid('getSelections');	//获取所有选中的行
		var selectRows = [];
		if(datas==""){
			$.messager.alert('提示',"未选中要删除的行!","info");						
			return false;
		}
		for ( var i= 0; i< datas.length; i++) {
		    selectRows.push(datas[i]);
		}		
		if(datas.length>0){									
			for(var j =0;j<selectRows.length;j++){
			    var index = $('#'+from).datagrid('getRowIndex',selectRows[j]);
			    $('#'+from).datagrid('deleteRow',index);
			}		
		}	
	}
	GetClinicTypeDesc=function(RLClinicType)
	{
			
		var ClinicTypeDesc=""
		for (var key in RLClinicType)
		{

			if (ClinicTypeDesc=="")
			{
				ClinicTypeDesc=RLClinicType[key]
			}
			else
			{
				ClinicTypeDesc=ClinicTypeDesc+","+RLClinicType[key]
			}			
		}
		//就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
		ClinicTypeDesc=ClinicTypeDesc.replace('O', '门诊');
		ClinicTypeDesc=ClinicTypeDesc.replace('E', '急诊');
		ClinicTypeDesc=ClinicTypeDesc.replace('I', '住院');
		ClinicTypeDesc=ClinicTypeDesc.replace('H', '体检');
		ClinicTypeDesc=ClinicTypeDesc.replace('N', '新生儿');
		return ClinicTypeDesc
	}
	
	//添加到检查表里  
	AddToList=function() {
		$('#creategrid').datagrid('loadData', { total: 0, rows: [] });
		var hosp=$("#ItemHospital").combobox("getValue")
		var hospdata=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",hosp)
		hospdata=eval('('+hospdata+')')
		var hospgroup=hospdata.list[0].HOSPDefaultHospitalDR

		var RLCTHospitalDR=$('#ARCRLCTHospitalDR').combobox('getText');
		var RLOrderPriorityDR=$('#ARCRLOrderPriorityDR').combobox('getText');	//获取医嘱优先级
		var RLFunction=$('#ARCRLFunction').combobox('getValue');

		var RLClinicType=$('#ARCRLClinicType').combobox('getValues');
		
		RLClinicType=GetClinicTypeDesc(RLClinicType)
		
		var ItemMastStr=GetData("selecteditemmastgrid");

		var HospPatLocStr=GetHosp("patlocgrid")

		var PatLocStr=GetData("patlocgrid");
		var RecLocStr=GetData("reclocgrid");
		var ItemMastIdStr=GetDataId("selecteditemmastgrid");		
		var PatLocIdStr=GetDataId("patlocgrid");
		var RecLocIdStr=GetDataId("reclocgrid");
		
		var RLDateFrom=$('#ARCRLDateFrom').datetimebox('getValue');
	  	var RLTimeFrom = $('#ARCRLTimeFrom').timespinner('getValue');

	  	//var DateTo = $('#ARCRLDateTo').datetimebox('getValue');
		//RLDateTo = DateTo.split(" ")
		var RLDateTo=$('#ARCRLDateTo').datetimebox('getValue');
		var RLTimeTo = $('#ARCRLTimeTo').timespinner('getValue');
		var ruleflag=$("input[name='rule']:checked").val();	
		
		var selrow=$('#selecteditemmastgrid').datagrid("getRows");
		var patrow=$('#patlocgrid').datagrid("getRows");
		var recrow=$('#reclocgrid').datagrid("getRows");
		
		if(selrow.length==0){ 								 
			$.messager.alert('提示',"请选择医嘱项!","info");
	  		return false;
		 }
		 /*if(patrow.length==0){									//update 2019-10-11 钟荣枫 病人科室可以为空
			$.messager.alert('提示',"请选择病人科室!","info");
	  		
	  		return false;
		 }*/
		 if(recrow.length==0){
			$.messager.alert('提示',"请选择接收科室!","info");
	  		return false;
		 }
		 if((RLFunction=="")||(RLFunction=="undefined")||(RLFunction==undefined)){
			$.messager.alert('提示',"请选择功能!","info");
	  		return false;
		}
		if (RLDateFrom == "") {
			$.messager.alert('提示',"请添加开始日期!","info");
		 	
	  		return ;
		}

		if ((RLDateFrom != "") && (RLDateTo != "")) {
			var datefrom=tkMakeServerCall("web.DHCBL.BDP.FunLib","DateHtmlToLogical",RLDateFrom)
			var dateto=tkMakeServerCall("web.DHCBL.BDP.FunLib","DateHtmlToLogical",RLDateTo)
			if (datefrom > dateto) {
				$.messager.alert('提示',"开始日期不能大于结束日期!","info");
				
				 	return;
				}
   		}
   		if (((RLTimeFrom=="")&&(RLTimeTo != ""))||((RLTimeFrom!="")&&(RLTimeTo== ""))) 
   		{
   			$.messager.alert('提示',"开始时间和结束时间需同时填写!","info");
        				
          	return;
   		}
   			 	
	 	if ((RLTimeFrom!="")&&(RLTimeTo != "")) {
	 		var timefrom=tkMakeServerCall("web.DHCBL.BDP.FunLib","TimeHtmlToLogical",RLTimeFrom)
			var timeto=tkMakeServerCall("web.DHCBL.BDP.FunLib","TimeHtmlToLogical",RLTimeTo)
	 		if (timefrom>=timeto) {
	 			$.messager.alert('提示',"结束时间必须大于开始时间!","info");			
			 	return;
			}
	 	}
	 	
		if(typeof(ruleflag)=="undefined"){
			$.messager.alert('提示',"请选择其中一种规则!","info");
	  		
	  		return false;
		 }
		var RLDefaultFlag=$('#ARCRLDefaultFlag').checkbox('getValue');
		if(RLDefaultFlag==true){
			RLDefaultFlag="Y";
		}
		else{
			RLDefaultFlag="N";
		}
		var ItemMastStrArry=ItemMastStr.split("^");
		var PatLocStrArry=PatLocStr.split("^");
		var RecLocStrArry=RecLocStr.split("^");

		var HospPatLocArry=HospPatLocStr.split("^");		
		
		var ItemMastIdArry=ItemMastIdStr.split("^");
		var PatLocIdArry=PatLocIdStr.split("^");
		var RecLocIdArry=RecLocIdStr.split("^");
		if (RLDefaultFlag=="Y") {
			if(PatLocStrArry.length==1){		//空对多
				if(RecLocStrArry.length!=2){
					RecLocStrArry.length=2;
					ruleflag=0;
					
				}
			}else{								//接收科室大于1时，只可一对一默认
				if ((ruleflag==1)&&(RecLocStrArry.length!=2)) {
					//alert(RecLocStrArry.length)
					$.messager.alert('提示',"接收科室大于一时，只可一对一默认!","info");
					return;
				}
			}


		}
		
		if(ruleflag==0){		//	一对一
			if(PatLocStrArry.length==1){
				PatLocStrArry.length=2;
			}else{
				if(PatLocStrArry.length!=RecLocStrArry.length){		//病人科室数与接收科室不等的情况
					$.messager.alert('提示',"请确定病人科室/接收科室数量相等！","info");
					return false;
			   	}
			}
			for(var i=1;i<ItemMastStrArry.length;i++){			
					var ItemMast=ItemMastStrArry[i];
				   var ItemMastId=ItemMastIdArry[i]
				   var HospCat=hospgroup
				   
		
					for(var j=1;j<PatLocStrArry.length;j++){
						var HospPat=HospPatLocArry[j];
						var SameHosp=""
						if (HospCat==HospPat)
						{
							SameHosp="是"
						}
						else
						{
							SameHosp="否"
						}
						var PatLoc=PatLocStrArry[j];
						var	RecLoc=RecLocStrArry[j];
						var	PatLocId=PatLocIdArry[j];
						var	RecLocId=RecLocIdArry[j];	
						$('#creategrid').datagrid('appendRow',{	
								ItemMast: ItemMast,
								PatLoc:PatLoc,
								RecLoc:RecLoc,
								SameHosp:SameHosp,
								RLDefaultFlag:RLDefaultFlag,								
								TItemMastId:ItemMastId,
								TPatLocId:PatLocId,
								TRecLocId:RecLocId,
								RLCTHospitalDR:RLCTHospitalDR,
								RLOrderPriorityDR:RLOrderPriorityDR,
								RLDateFrom:RLDateFrom,
								RLDateTo:RLDateTo,
								RLTimeFrom:RLTimeFrom,
								RLTimeTo:RLTimeTo,
                				RLClinicType:RLClinicType,
				                RLFunction:RLFunction
						})
					}
			}										
			
		}else{				//	多对多
			if(PatLocStrArry.length==1){
				PatLocStrArry.length=2;
			}
			for(var i=1;i<ItemMastStrArry.length;i++){			
				   var ItemMast=ItemMastStrArry[i];
				   var ItemMastId=ItemMastIdArry[i]
				   var HospCat=hospgroup
					for(var j=1;j<PatLocStrArry.length;j++){
						var HospPat=HospPatLocArry[j];
						var SameHosp=""
						if (HospCat==HospPat)
						{
							SameHosp="是"
						}
						else
						{
							SameHosp="否"
						}
						var PatLoc=PatLocStrArry[j];
						var	PatLocId=PatLocIdArry[j];
						for(var k=1;k<RecLocStrArry.length;k++){
							var	RecLoc=RecLocStrArry[k];
							var	RecLocId=RecLocIdArry[k];
							
							$('#creategrid').datagrid('appendRow',{	
									ItemMast: ItemMast,
									PatLoc:PatLoc,
									RecLoc:RecLoc,
									SameHosp:SameHosp,
									RLDefaultFlag:RLDefaultFlag,								
									TItemMastId:ItemMastId,
									TPatLocId:PatLocId,
									TRecLocId:RecLocId,
									RLCTHospitalDR:RLCTHospitalDR,
									RLOrderPriorityDR:RLOrderPriorityDR,
									RLDateFrom:RLDateFrom,
									RLDateTo:RLDateTo,
									RLTimeFrom:RLTimeFrom,
									RLTimeTo:RLTimeTo,
                 				 	RLClinicType:RLClinicType,
				                	RLFunction:RLFunction
							})
						}	
					}
			}		
		}
		return true;
	}
	///数据检测按钮点击事件
	Check=function ()
	{
		
		$('#resultgrid').datagrid('loadData', { total: 0, rows: [] });
		
		var rows = $("#creategrid").datagrid("getRows"); 
		var RLClinicType=$('#ARCRLClinicType').combobox('getValues');

		var RLOrderPriorityDR=$('#ARCRLOrderPriorityDR').combobox('getValue');
        var RLCTHospitalDR=$('#ARCRLCTHospitalDR').combobox("getValue");
        //var DateFrom=$('#ARCRLDateFrom').datetimebox('getValue');
        var RLDateFrom=$('#ARCRLDateFrom').datetimebox('getValue');
        var RLTimeFrom=$('#ARCRLTimeFrom').timespinner('getValue');	
        //var DateTo=$('#ARCRLDateTo').datetimebox('getValue');
        var RLDateTo=$('#ARCRLDateTo').datetimebox('getValue');
        var RLTimeTo=$('#ARCRLTimeTo').timespinner('getValue');
        var RLDefaultFlag=$('#ARCRLDefaultFlag').checkbox('getValue');
		if(RLDefaultFlag==true){
			RLDefaultFlag="Y";
		}
		else{
			RLDefaultFlag="N";
		}
		for(var i=0;i<rows.length;i++){
			
			var ItemMast=rows[i].ItemMast;	
			var RecLoc=rows[i].RecLoc;	
			var PatLoc=rows[i].PatLoc;	
			
			if (PatLoc==undefined) {
				
				PatLoc="";
			}
			var TItemMastId=rows[i].TItemMastId;
			var RecLocId=rows[i].TRecLocId;
			var PatLocId=rows[i].TPatLocId;
			if (PatLocId==undefined) {
				PatLocId="";
				
			}
			var parref=TItemMastId.split("||")[0]
			//s str=priordr_"^"_timefrom_"^"_timeto_"^"_datefrom_"^"_dateto _"^"_hospditaldr_"^"_ARCRLClinicType
			var str=RLOrderPriorityDR+"^"+RLTimeFrom+"^"+RLTimeTo+"^"+RLDateFrom+"^"+RLDateTo+"^"+RLCTHospitalDR+"^"+RLClinicType+"^1"
			var flag=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","FormValidate",parref,"",RecLocId,PatLocId,str);
			/*if (flag==1) {
				var  result = "与另一条相同接收科室记录的日期时间冲突，请确认！"
				$.messager.alert('提示',result,"info");
			}*/
			var WarningMsg="";
			var flag2=0;
			if(RLDefaultFlag=="Y"){
	 			//str=^00:59:59^23:59:59^2019-10-12^^
		 		flag2=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","GetDefRecLoc",parref,"",PatLocId,str);
		 						
		 		if (flag2==1)
		 		{
		 			WarningMsg='已经存在默认规则!'
		 		}
		 		else if (flag2==2)
		 		{
		 			WarningMsg='医嘱项与病人科室不在同一个医院组!'
		 		}

	 		} 
	 		var Data=ItemMast+"#"+PatLoc+"#"+RecLoc;
	 		var Tips="";	
			if(flag!=1){
				if (flag==2)
				{
					Tips='医嘱项与病人科室不在同一个医院组!'
				}
				else{
					Tips="【"+ItemMast+"】"+"未维护科室为"+"【"+PatLoc+"】到:【"+RecLoc+"】"+"的接收科室";
				}
				$('#resultgrid').datagrid('appendRow',{			
					Data: Data,
					Tips: Tips								
				});	
			}
			else{
				
				if(flag2!=0) {
					Tips=WarningMsg;
				}else{
					Tips="已存在数据";
				}
					
				$('#resultgrid').datagrid('appendRow',{	
						
					Data: Data,
					Tips: Tips							
				});	
			}
		}
				
		
		$("#WinResult").show();
		var myWin = $HUI.dialog("#WinResult",{			
			resizable:true,
			iconCls:'icon-w-list',
			title:'校验结果',
			modal:true,
			width: windowWidth-200,    
   			height: windowHight-50,
			buttonAlign : 'center',
			buttons:[{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myWin.close();
				}
			}]					
		});			
	}
	//导入 保存 
	SaveFunLib=function(){
		$('#resultgrid').datagrid('loadData', { total: 0, rows: [] });
		var rows  = $('#creategrid').datagrid("getRows");
		var RLFunction=$('#ARCRLFunction').combobox('getValue');
		var RLClinicType=$('#ARCRLClinicType').combobox('getValues');
		var RLDefaultFlag=$('#ARCRLDefaultFlag').checkbox('getValue');
		if(RLDefaultFlag==true){
			RLDefaultFlag="Y";
		}
		else{
			RLDefaultFlag="N";
		}

		for(var i=0;i<rows.length;i++){


			var ItemMast=rows[i].ItemMast;	
			var RecLoc=rows[i].RecLoc;	
			var PatLoc=rows[i].PatLoc;			
			var RLRowId="";
			var TItemMastId=rows[i].TItemMastId;
			var RLOrdLocDR=rows[i].TPatLocId;
			var RLRecLocDR=rows[i].TRecLocId;
			
			//var RLDefaultFlag=rows[i].RLDefaultFlag;
			if(RLOrdLocDR==undefined){										
				RLOrdLocDR="";
			}
			if(PatLoc==undefined){										
				PatLoc="";
			}
			var RLCTHospitalDR=$('#ARCRLCTHospitalDR').combobox('getValue');
			var RLDateFrom=rows[i].RLDateFrom;
			var RLDateTo=rows[i].RLDateTo;
			var RLTimeFrom=rows[i].RLTimeFrom;
			var RLTimeTo=rows[i].RLTimeTo;
			var RLOrderPriorityDR=$('#ARCRLOrderPriorityDR').combobox('getValue');	

			var parref=TItemMastId.split("||")[0]
			

			var str=RLOrderPriorityDR+"^"+RLTimeFrom+"^"+RLTimeTo+"^"+RLDateFrom+"^"+RLDateTo+"^"+RLCTHospitalDR+"^"+RLClinicType+"^1"
			var flag=0;
			if (RLDefaultFlag=="Y"){
				flag=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","GetDefRecLoc",parref,"",RLOrdLocDR,str);
			}

			if (flag==1){

				$('#resultgrid').datagrid('appendRow',{			
					Data: ItemMast+"#"+PatLoc+"#"+RecLoc,
					Tips:"已经存在默认规则!"								
				});
				continue;
			}
			else if (flag==2)
			{
				$('#resultgrid').datagrid('appendRow',{			
					Data: ItemMast+"#"+PatLoc+"#"+RecLoc,
					Tips:"医嘱项与病人科室不在同一个医院组!"								
				});
				continue;
			}

      		var savestr=TItemMastId+"^"+RLOrdLocDR+"^"+RLRecLocDR+"^"+RLOrderPriorityDR+"^"+RLDateFrom+"^"+RLDateTo+"^"+RLTimeFrom+"^"+RLTimeTo+"^"+RLDefaultFlag+"^"+RLFunction+"^"+RLCTHospitalDR+"^"+RLClinicType
      		//arcimrowid^patlocdr^reclocdr^priordr^datefrom^dateto^timefrom^timeto^DefaultFlag^function^hospditaldr^ARCRLClinicType
      		var showdata=ItemMast+"#"+PatLoc+"#"+RecLoc
      		var result=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","AddReceiveLoc",savestr);			
			var result=eval('('+result+')');
			if(result.success == 'true'){
				$('#resultgrid').datagrid('appendRow',{	
					//Data: strobj.RLParRef+"#"+ strobj.RLOrdLocDR+"#"+strobj.RLOrdLocDR,
					Data: showdata,
					Tips:"保存成功！"								
				});	
			}
			else{							
				$('#resultgrid').datagrid('appendRow',{			
					Data: showdata,
					Tips:"保存失败!"+"错误信息:" + result.info							
				});	
			}
          
		}		
	}
	//获取所有行的医院 
	GetHosp=function(from){
		var rows = $("#"+from).datagrid("getRows"); 
		var str="";
		var flag=1;
		for(var i=0;i<rows.length;i++)
		{						
				str=str+"^"+rows[i].Hospital;					
		}
		return str;
	}	

	//获取所有行数据
	GetData=function(from){
		var rows = $("#"+from).datagrid("getRows"); 
		var str="";
		var flag=1;
		for(var i=0;i<rows.length;i++)
		{
			for(var j=0;j<i;j++){
				if(rows[j].Data!=rows[i].Data){
					flag=1;
				}else{
					flag=0;	
					break;
				}				
			}
			if(flag){
				str=str+"^"+rows[i].Data;
			}else{
				continue;
			}			
		}
		return str;
	}
	//获取所有行数据ID
	GetDataId=function(from){
		var rows = $("#"+from).datagrid("getRows"); //这段代码是获取当前页的所有行。
		var str="";
		var flag=1;
		for(var i=0;i<rows.length;i++)
		{		 
			for(var j=0;j<i;j++){
				if(rows[j].Id!=rows[i].Id){
					flag=1;
				}else{
					flag=0;	
					break;
				}				
			}
			if(flag){
				str=str+"^"+rows[i].Id;
			}else{
				continue;
			}				
		}
		return str;
	}
	//获取当前日期
	function getCurentDateStr()
	{ 
		var now = new Date();
	    var year = now.getFullYear();       //年
	    var month = now.getMonth() + 1;     //月
	    var day = now.getDate();            //日
	    var clock = year + "-";
	    if(month < 10) clock += "0";       
	    clock += month + "-";
	    if(day < 10) clock += "0"; 
	    clock += day;
	    return clock; 
	}

	$('#ARCRLDateFrom').datebox('setValue', getCurentDateStr());	//开始日期默认当天		

	//功能
	$('#ARCRLFunction').combobox({ 
		data:[{'value':'Execute','text':'Execute'},{'value':'Processing','text':'Processing'}],
		valueField:'value',
		textField:'text',
		onLoadSuccess:function(){
			var data = $(this).combobox('getData');
 			$(this).combobox('select',data[0].value);
		}
		
	});

	//医嘱优先级下拉框 
	$('#ARCRLOrderPriorityDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.OECPriority&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'OECPRRowId',
		textField:'OECPRDesc'
		
	});		
	//Disable(1,author,myTMenuID,ObjectType,ObjectReference);	
		
}
 $(init);