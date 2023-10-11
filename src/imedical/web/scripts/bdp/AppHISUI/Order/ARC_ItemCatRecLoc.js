 /**
 * @Author: 钟荣枫 DHC-BDP
 * @Description: 用于接收科室生成页面。
 * @Created on 2019-9

 */
 var init=function(){
 	var addurl="dhc.bdp.ext.sys.csp?BDPMENU=54"
 	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.ARCItemCatRecLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.ARCItemCatRecLoc";
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
		ReloadOECOrderCategory()
		SearchItemCat();		

		$('#LocHospital').combobox("setValue",defaultHosp)		
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

	//医嘱子类表格内 医院下拉框
	$('#ItemHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=ARC_ItemCat",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			ReloadOECOrderCategory()
			SearchItemCat();
		}
	});

	ReloadOECOrderCategory=function(){
		$('#OECOrderCategory').combobox('setValue','');
		var ItemHospital=$('#ItemHospital').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.OECOrderCategory&QueryName=GetDataForCmb1&ResultSetType=array&hospid=" +ItemHospital;
      	$('#OECOrderCategory').combobox('reload',url);
	}
 	//医嘱大类下拉框 
	$('#OECOrderCategory').combobox({ 
		//url:$URL+"?ClassName=web.DHCBL.CT.OECOrderCategory&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'ORCATRowId',
		textField:'ORCATDesc',
		width: (windowWidth-158)*0.27*0.5,
		onSelect:function(record){
			SearchItemCat();
		}
	});	
	//医嘱子类描述查找

	$('#ItemCatDesc').searchbox({
		width: (windowWidth-158)*0.27*0.5,
		searcher:function(value,name){
			SearchItemCat();
		}
	});
	//刷新
	$("#btnItemCatRefresh").click(function (e) { 
		var data=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",session['LOGON.HOSPID'])
	    var data = eval('(' + data + ')');
	    var defaultHosp=data.list[0].HOSPDefaultHospitalDR  
		$('#ItemHospital').combobox("setValue",defaultHosp)
		
		$('#OECOrderCategory').combobox('setValue','');
		$("#ItemCatDesc").searchbox('setValue', '');
		SearchItemCat();
	 }) 
 	//查找医嘱子类
 	SearchItemCat=function(){
 		$('#itemcatgrid').datagrid('clearSelections');		//清除选中
 		var OECOrderCategory=$('#OECOrderCategory').combobox('getValue');
		var ItemCatDesc=$.trim($("#ItemCatDesc").searchbox('getValue'));
		var Hospital=$('#ItemHospital').combobox('getValue');
 		$('#itemcatgrid').datagrid('load',  { 
				'ClassName':"web.DHCBL.CT.ARCItemCat",
				'QueryName':"GetList",
				'OrderCat': OECOrderCategory,
				'desc':ItemCatDesc,
				'hospid':Hospital
		});	
			
 	}
 	

	//医嘱子类
	var itemcatgrid=$HUI.datagrid('#itemcatgrid',{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.ARCItemCat",
			QueryName:"GetList"					
		},
		columns:[[								
				{field:'ARCICRowId',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'ARCICDesc',title:'描述',width:80,sortable:true},
				{field:'ARCICOrdCatDR',title:'医嘱大类描述',width:80,sortable:true,hidden:true},
				{field:'HospitalGroupDR',title:'所属医院组DR',width:80,sortable:true,hidden:true}
												
				]],	
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.4-8-50)*0.7,					
		idField:'ARCICRowId',
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
		toolbar: "#itemcatbar",
        onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        },
        onClickRow:function(index,row){
        	grid="itemcatgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#itemcatgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#itemcatgrid').datagrid('selectRow', i);
	            }
	        }
        }

	});		


	//被选中的医嘱子类 selecteditemcatgrid
	var selecteditemcatgrid=$HUI.datagrid('#selecteditemcatgrid',{
				
		columns:[[	
				{field:'Id',title:'ID',width:40,sortable:true,hidden:true},//,hidden:true
				{field:'Data',title:'描述',width:80,sortable:true},
				{field:'OrdCatId',title:'医嘱大类描述',width:80,sortable:true,hidden:true},
				{field:'Hospital',title:'所属医院',width:80,sortable:true,hidden:true}
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
		toolbar: [],
        onClickRow:function(index,row){
        	grid="selecteditemcatgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#selecteditemcatgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#selecteditemcatgrid').datagrid('selectRow', i);
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
		$('#LocHospital').combobox('setValue',defaultHosp);
		$('#LocGroup').combobox('reload');
		$('#LocGroup').combobox('setValue','');
		//$('#LocGroup').combobox('reload');
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
				'desc':	LocDesc,
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
				{field:'Hospital',title:'所属医院',width:80,sortable:true,hidden:true}
				]],		
		pageSize:20,
		height: windowHight-130-20,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.25,		
		singleSelect:false,	
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		fitColumns:true, 
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,
		idField:'Id',
		toolbar: [],
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
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		fitColumns:true, 
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,
		idField:'Id',
		toolbar: [],
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
	$('#RLCTHospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
	});

	//就诊类型   就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
	$('#RLClinicType').combobox({ 
		data:[
			{id:'O',text:'门诊'},{id:'E',text:'急诊'},{id:'I',text:'住院'}
			,{id:'H',text:'体检'},{id:'N',text:'新生儿'}
		],
		valueField:'id',
		textField:'text'
		
	});

	
	
	var createcol =[[  
				  {field:'CatSub',title:'医嘱大类',width:100,sortable:true},
				  {field:'SelCatSub',title:'医嘱子类',width:150,sortable:true},
				  {field:'PatLoc',title:'病人科室',width:200,sortable:true},
				  {field:'RecLoc',title:'接收科室',width:200,sortable:true},
				  {field:'SameHosp',title:'是否同一医院组',width:150,sortable:true},

				  {field:'RLDefaultFlag',title:'默认',width:60,sortable:true,formatter:ReturnFlagIcon},
				  {field:'TCatSubId',title:'TCatSubId',width:80,sortable:true,hidden:true},
				  {field:'TPatLocId',title:'TPatLocId',width:80,sortable:true,hidden:true},
				  {field:'TRecLocId',title:'TRecLocId',width:80,sortable:true,hidden:true},
				  {field:'RLDateFrom',title:'开始日期',width:100,sortable:true},
				  {field:'RLDateTo',title:'结束日期',width:100,sortable:true},
				  {field:'RLTimeFrom',title:'开始时间',width:100,sortable:true},
				  {field:'RLTimeTo',title:'结束时间',width:100,sortable:true},
				  {field:'RLCTHospitalDR',title:'医院',width:200,sortable:true},
				  {field:'RLOrderPriorityDR',title:'医嘱优先级',width:100,sortable:true},
				  {field:'RLFunction',title:'功能',width:100,sortable:true},
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
	//添加医嘱子类 addOrdCatSub
	$("#addOrdCatSub").click(function(e) {		
		AddFunlib("itemcatgrid","selecteditemcatgrid");
	});
	//添加病人科室按钮 addPatLoc
	$("#addPatLoc").click(function(e) {
		AddFunlib("locgrid","patlocgrid");
	});
	//添加接收科室按钮 addRecLoc
	$("#addRecLoc").click(function(e) {
		AddFunlib("locgrid","reclocgrid");
	});
	//删除医嘱子类 delOrdCatSub
	$("#delOrdCatSub").click(function(e) {		
		DeleteFunlib("selecteditemcatgrid");
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
			
			for(var i=0;i<datas.length;i++)
			{	
				var data="";
				var id="";
				var OrdCatId="";
				var Hospital=""
				
				switch(from)
				{
					case "itemcatgrid": data=datas[i].ARCICDesc
					id=datas[i].ARCICRowId	
					OrdCatId=datas[i].ARCICOrdCatDR
					Hospital=datas[i].HospitalGroupDR
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
					if(from=="itemcatgrid"){
						$('#'+to).datagrid('appendRow',{			
							Data: data,
							Id:id,
							OrdCatId:OrdCatId,
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
		if ('undefined'!==typeof websys_getMWToken){
			addurl += "&MWToken="+websys_getMWToken()
		}
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
		//selecteditemcatgrid patlocgrid reclocgrid
		$('#itemcatgrid').datagrid('clearSelections');
		//$('#ordercatgrid').datagrid('clearSelections');
		$('#locgrid').datagrid('clearSelections');		
		//$('#locgroupgrid').datagrid('clearSelections');
		$('#selecteditemcatgrid').datagrid('loadData', { total: 0, rows: [] });			
		$('#patlocgrid').datagrid('loadData', { total: 0, rows: [] });	
		$('#reclocgrid').datagrid('loadData', { total: 0, rows: [] });
		
		$('#OECOrderCategory').combobox('setValue',"");	//置空医嘱大类
		$("#ItemCatDesc").searchbox('setValue', '');		//置空医嘱子类描述
		
		$('#LocGroup').combobox('setValue',"");	//置空科室组
		$('#RLCTHospitalDR').combobox('setValue',"");	//置空医院
		$("#LocDesc").searchbox('setValue', '');			//置空科室描述
		$('#RLOrderPriorityDR').combobox('setValue',"");	//置空医嘱优先级
		$('#RLFunction').combobox('setValue',"");	//置空功能
		$('#RLClinicType').combobox('setValues',[]);	
		

		//$('#RLDateFrom').datebox('setValue', "");
		$('#RLDateFrom').datebox('setValue', getCurentDateStr());	
		$('#RLDateTo').datebox('setValue', "");	
		$('#RLTimeFrom').timespinner('setValue',"");			
		$('#RLTimeTo').timespinner('setValue',"");	
		$HUI.checkbox("#RLDefaultFlag").setValue(false);
		$HUI.radio("#OneToOne").setValue(true);
		$HUI.radio("#ManyToMany").setValue(false);
		//$('#itemcatgrid').datagrid('reload');
	
		//$('#locgrid').datagrid('reload');
		SearchItemCat()
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
		
		var RLCTHospitalDR=$('#RLCTHospitalDR').combobox('getText');
		var RLOrderPriorityDR=$('#RLOrderPriorityDR').combobox('getText');	//获取医嘱优先级
		var RLFunction=$('#RLFunction').combobox('getValue');

		var RLClinicType=$('#RLClinicType').combobox('getValues');
		
		RLClinicType=GetClinicTypeDesc(RLClinicType)
		
		var OrdCatStr= GetOrdCat("selecteditemcatgrid");
		var SelCatSubStr=GetData("selecteditemcatgrid");
		var HospCatStr=GetHosp("selecteditemcatgrid")

		var HospPatLocStr=GetHosp("patlocgrid")

		var PatLocStr=GetData("patlocgrid");
		var RecLocStr=GetData("reclocgrid");
		var SelCatSubIdStr=GetDataId("selecteditemcatgrid");		
		var PatLocIdStr=GetDataId("patlocgrid");
		var RecLocIdStr=GetDataId("reclocgrid");
		
		var RLDateFrom=$('#RLDateFrom').datetimebox('getValue');
	  	var RLTimeFrom = $('#RLTimeFrom').timespinner('getValue');

	  	//var DateTo = $('#RLDateTo').datetimebox('getValue');
		//RLDateTo = DateTo.split(" ")
		var RLDateTo=$('#RLDateTo').datetimebox('getValue');
		var RLTimeTo = $('#RLTimeTo').timespinner('getValue');
		var ruleflag=$("input[name='rule']:checked").val();	
		
		var selrow=$('#selecteditemcatgrid').datagrid("getRows");
		var patrow=$('#patlocgrid').datagrid("getRows");
		var recrow=$('#reclocgrid').datagrid("getRows");
		
		if(selrow.length==0){ 								 
			$.messager.alert('提示',"请选择医嘱子类!","info");
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
		var RLDefaultFlag=$('#RLDefaultFlag').checkbox('getValue');
		if(RLDefaultFlag==true){
			RLDefaultFlag="Y";
		}
		else{
			RLDefaultFlag="N";
		}
		var OrdCatArry=OrdCatStr.split("^");
		var SelCatSubStrArry=SelCatSubStr.split("^");
		var PatLocStrArry=PatLocStr.split("^");
		var RecLocStrArry=RecLocStr.split("^");

		var HospCatArry=HospCatStr.split("^");
		var HospPatLocArry=HospPatLocStr.split("^");		
		
		var SelCatSubIdArry=SelCatSubIdStr.split("^");
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
			for(var i=1;i<SelCatSubStrArry.length;i++){			
					var SelCatSub=SelCatSubStrArry[i];
				   var SelCatSubId=SelCatSubIdArry[i]
				   var OrdCat=OrdCatArry[i];
				   var HospCat=HospCatArry[i]
				   
		
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
						//alert(HospCat+"--"+HospPat)
						var PatLoc=PatLocStrArry[j];
						var	RecLoc=RecLocStrArry[j];
						var	PatLocId=PatLocIdArry[j];
						var	RecLocId=RecLocIdArry[j];	
						$('#creategrid').datagrid('appendRow',{	
								CatSub:OrdCat,
								SelCatSub: SelCatSub,
								PatLoc:PatLoc,
								RecLoc:RecLoc,
								SameHosp:SameHosp,
								RLDefaultFlag:RLDefaultFlag,								
								TCatSubId:SelCatSubId,
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
			for(var i=1;i<SelCatSubStrArry.length;i++){			
				   var SelCatSub=SelCatSubStrArry[i];
				   var SelCatSubId=SelCatSubIdArry[i]
				   var OrdCat=OrdCatArry[i];
				   var HospCat=HospCatArry[i]
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
									CatSub:OrdCat,		
									SelCatSub: SelCatSub,
									PatLoc:PatLoc,
									RecLoc:RecLoc,
									SameHosp:SameHosp,
									RLDefaultFlag:RLDefaultFlag,								
									TCatSubId:SelCatSubId,
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
		var RLClinicType=$('#RLClinicType').combobox('getValues');

		var RLOrderPriorityDR=$('#RLOrderPriorityDR').combobox('getValue');
        var RLCTHospitalDR=$('#RLCTHospitalDR').combobox("getValue");
        //var DateFrom=$('#RLDateFrom').datetimebox('getValue');
        var RLDateFrom=$('#RLDateFrom').datetimebox('getValue');
        var RLTimeFrom=$('#RLTimeFrom').timespinner('getValue');	
        //var DateTo=$('#RLDateTo').datetimebox('getValue');
        var RLDateTo=$('#RLDateTo').datetimebox('getValue');
        var RLTimeTo=$('#RLTimeTo').timespinner('getValue');
        var RLDefaultFlag=$('#RLDefaultFlag').checkbox('getValue');
		if(RLDefaultFlag==true){
			RLDefaultFlag="Y";
		}
		else{
			RLDefaultFlag="N";
		}
		for(var i=0;i<rows.length;i++){
			
			var SelCatSub=rows[i].SelCatSub;	
			var RecLoc=rows[i].RecLoc;	
			var PatLoc=rows[i].PatLoc;	
			
			if (PatLoc==undefined) {
				
				PatLoc="";
			}
			var SelCatSubId=rows[i].TCatSubId;
			var RecLocId=rows[i].TRecLocId;
			var PatLocId=rows[i].TPatLocId;
			if (PatLocId==undefined) {
				PatLocId="";
				
			}
			var str=RLOrderPriorityDR+"^"+RLTimeFrom+"^"+RLTimeTo+"^"+RLDateFrom+"^"+RLDateTo+"^"+RLCTHospitalDR+"^"+RLClinicType
			var flag=tkMakeServerCall("web.DHCBL.CT.ARCItemCatRecLoc","FormValidate",SelCatSubId,"",RecLocId,PatLocId,str);
			/*if (flag==1) {
				var  result = "与另一条相同接收科室记录的日期时间冲突，请确认！"
				$.messager.alert('提示',result,"info");
			}*/
			var WarningMsg="";
			var flag2=0;
			if(RLDefaultFlag=="Y"){
	 			//str=^00:59:59^23:59:59^2019-10-12^^
		 		flag2=tkMakeServerCall("web.DHCBL.CT.ARCItemCatRecLoc","GetDefRecLoc",SelCatSubId,"",PatLocId,str);
		 						
		 		if (flag2==1)
		 		{
		 			WarningMsg='已经存在默认规则!'
		 		}
		 		else if (flag2==2)
		 		{
		 			WarningMsg='医嘱子类与病人科室不在同一个医院组!'
		 		}

	 		} 
	 		var Data=SelCatSub+"#"+PatLoc+"#"+RecLoc;
	 		var Tips="";	
			if(flag!=1){
				if (flag==2)
				{
					Tips='医嘱子类与病人科室不在同一个医院组!'
				}
				else{
					Tips="【"+SelCatSub+"】"+"未维护科室为"+"【"+PatLoc+"】到:【"+RecLoc+"】"+"的接收科室";
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
		var RLFunction=$('#RLFunction').combobox('getValue');
		var RLClinicType=$('#RLClinicType').combobox('getValues');

		for(var i=0;i<rows.length;i++){


			var SelCatSub=rows[i].SelCatSub;	
			var RecLoc=rows[i].RecLoc;	
			var PatLoc=rows[i].PatLoc;			
			var RLRowId="";
			var TCatSubId=rows[i].TCatSubId;
			var RLOrdLocDR=rows[i].TPatLocId;
			var RLRecLocDR=rows[i].TRecLocId;
			
			var RLDefaultFlag=rows[i].RLDefaultFlag;
			if(RLOrdLocDR==undefined){										
				RLOrdLocDR="";
			}
			if(PatLoc==undefined){										
				PatLoc="";
			}
			var RLCTHospitalDR=$('#RLCTHospitalDR').combobox('getValue');
			var RLDateFrom=rows[i].RLDateFrom;
			var RLDateTo=rows[i].RLDateTo;
			var RLTimeFrom=rows[i].RLTimeFrom;
			var RLTimeTo=rows[i].RLTimeTo;
			var RLOrderPriorityDR=$('#RLOrderPriorityDR').combobox('getValue');		
			var strs=RLOrderPriorityDR+"^"+RLTimeFrom+"^"+RLTimeTo+"^"+RLDateFrom+"^"+RLDateTo+"^"+RLCTHospitalDR+"^"+RLClinicType
			var flag=0;
			if (RLDefaultFlag=="Y"){
				flag=tkMakeServerCall("web.DHCBL.CT.ARCItemCatRecLoc","GetDefRecLoc",TCatSubId,"",RLOrdLocDR,strs);
			}
			
			if (flag==1){
				$('#resultgrid').datagrid('appendRow',{			
					Data: SelCatSub+"#"+PatLoc+"#"+RecLoc,
					Tips:"已经存在默认规则！"								
				});
				continue;
			}
			else if (flag==2)
			{
				$('#resultgrid').datagrid('appendRow',{			
					Data: SelCatSub+"#"+PatLoc+"#"+RecLoc,
					Tips:"医嘱子类与病人科室不在同一个医院组!"								
				});
				continue;
			}
			var str='{"RLParRef":"'+TCatSubId+'","RLRowId":"","RLOrdLocDR":"'+RLOrdLocDR+'","RLRecLocDR":"'+RLRecLocDR+'","RLFunction":"'+RLFunction+'","RLDefaultFlag":"'+
			RLDefaultFlag+'","RLCTHospitalDR":"'+RLCTHospitalDR+'","RLDateFrom":"'+RLDateFrom+'","RLDateTo":"'+RLDateTo+'","RLTimeFrom":"'+RLTimeFrom+'","RLTimeTo":"'+
			RLTimeTo+'","RLOrderPriorityDR":"'+RLOrderPriorityDR+ '","RLClinicType":"'+RLClinicType+'"}';
      var strobj=eval('('+str+')');

			$.ajax({
					url:SAVE_ACTION_URL,  
					data:strobj,  
					type:"POST",   										
                    success: function (data) {
                   		//{success:'true',id:'83||1'}
                    	var data=eval('('+data+')'); 
                    	 //alert(strobj.RLParRef)                       
						if(data.success == 'true'){
							$('#resultgrid').datagrid('appendRow',{	
								//Data: strobj.RLParRef+"#"+ strobj.RLOrdLocDR+"#"+strobj.RLOrdLocDR,
								Data: data.ARCICDesc+"#"+data.RLOrdLocDesc+"#"+data.RLRecLocDesc,
								Tips:"保存成功！"								
							});	
						}
						else{							
							$('#resultgrid').datagrid('appendRow',{			
								Data: data.ARCICDesc+"#"+data.RLOrdLocDesc+"#"+data.RLRecLocDesc,
								Tips:"保存失败!"+"错误信息:" + data.errorinfo							
							});	
						}
                    }
                }); 	          
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

	//获取所有行数据DR
	GetOrdCat=function(from){
		var rows = $("#"+from).datagrid("getRows"); 
		var str="";
		var flag=1;
		for(var i=0;i<rows.length;i++)
		{						
				str=str+"^"+rows[i].OrdCatId;					
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

	$('#RLDateFrom').datebox('setValue', getCurentDateStr());	//开始日期默认当天		

	//功能
	$('#RLFunction').combobox({ 
		data:[{'value':'Execute','text':'Execute'},{'value':'Processing','text':'Processing'}],
		valueField:'value',
		textField:'text'
		
	});

	//医嘱优先级下拉框 
	$('#RLOrderPriorityDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.OECPriority&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'OECPRRowId',
		textField:'OECPRDesc'
		
	});		
	//Disable(1,author,myTMenuID,ObjectType,ObjectReference);	
				
}
 $(init);