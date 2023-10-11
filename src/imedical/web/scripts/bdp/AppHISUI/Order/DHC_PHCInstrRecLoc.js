 /**
 * @Author: 钟荣枫 DHC-BDP
 * @Description: 用于用法接收科室生成页面。
 * @Created on 2020-2-26

 */
 var init=function(){
	var reclocurl="dhc.bdp.ext.sys.csp?BDPMENU=118"
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.DHCPHCInstrRecLoc&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.DHCPHCInstrRecLoc";

 	var windowHight = document.documentElement.clientHeight;		//可获取到高度
 	var windowWidth = document.documentElement.clientWidth;
 	$(document).ready(function () {
        $("body")[0].onkeydown = keyPress;
        $("body")[0].onkeyup = keyRelease;
    });
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
    
 	//用法下拉框 
	$('#Instruct').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.PHCInstruc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'PHCINRowId',
		textField:'PHCINDesc1'
	});	
	
	//医嘱子类表格内 医院下拉框
	$('#ItemHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=ARC_ItemCat",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		width: (windowWidth-80)*0.27*0.5+2,
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

	//医嘱优先级下拉框 
	$('#InstrOrdPrior').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.OECPriority&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'OECPRRowId',
		textField:'OECPRDesc'
	});	

 	//医嘱大类下拉框 
	$('#OECOrderCategory').combobox({ 
		//url:$URL+"?ClassName=web.DHCBL.CT.OECOrderCategory&QueryName=GetDataForCmb1&ResultSetType=array&hospid=" +session['LOGON.HOSPID'],
		valueField:'ORCATRowId',
		textField:'ORCATDesc',
		width: (windowWidth-80)*0.27*0.5+2,
		onSelect:function(record){
			SearchItemCat();

		}
	});	
	//医嘱子类描述查找
	
	$('#ItemCatDesc').searchbox({
		width: (windowWidth-80)*0.27*0.5+2,
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
		height: windowHight-60-90+3-10+5+3,
		width:	((windowWidth-20-1)*0.4-8-50)*0.7,	
		idField:'ARCICRowId',
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
				{field:'Hospital',title:'所属医院',width:80,sortable:true,hidden:true}
				]],		
		pageSize:20,
		height: windowHight-60-90+3-10+5+3,
		width:	((windowWidth-20-1)*0.4-8-50)*0.3,		
		singleSelect:false,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		idField:'Id',
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,		
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

	//科室内 医院下拉框查询
	$('#LocHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		width: (windowWidth-125)*0.27*0.5+4,
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
		//url:$URL+"?ClassName=web.DHCBL.CT.RBCDepartmentGroup&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'DEPRowId',
		textField:'DEPDesc',
		width: (windowWidth-125)*0.27*0.5+4,
		onSelect:function(record){
			SearchLoc();
		}
	});
	
	//科室描述查找
	$('#LocDesc').searchbox({
		width: (windowWidth-125)*0.27*0.5+4,
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
		$("#LocDesc").searchbox('setValue', '');
		$('#LocGroup').combobox('reload','');
		SearchLoc();
	 })
	//查找科室	
	SearchLoc=function(){
		$('#locgrid').datagrid('clearSelections');		//清除选中
		var LocHospital=$('#LocHospital').combobox('getValue');
		var LocGroup=$('#LocGroup').combobox('getValue');
		
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
		height: windowHight-60-90+3-10+5+3,
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
		height: windowHight-60-90+3-10+5+3,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.25,
		singleSelect:false,	
		sortName:"Data",
		sortOrder:"asc",
		remoteSort:false,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fit: true, //自适应大小
		fitColumns:true, 
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
		height: windowHight-60-90+3-10+5+3,
		width:	((windowWidth-20-1)*0.6-16-98-6)*0.25,
		singleSelect:false,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
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
	$('#InstrHospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
	});
	
	var createcol =[[  
				  {field:'Instruct',title:'用法',width:80,sortable:true},
				  {field:'SelCatSub',title:'医嘱子类',width:150,sortable:true},
				  {field:'PatLoc',title:'病人科室',width:200,sortable:true},
				  {field:'RecLoc',title:'接收科室',width:200,sortable:true},
				  {field:'SameHosp',title:'是否同一医院组',width:150,sortable:true},
				  {field:'InstrDefault',title:'默认',width:60,sortable:true},
				  {field:'TCatSubId',title:'TCatSubId',width:80,sortable:true,hidden:true},
				  {field:'TPatLocId',title:'TPatLocId',width:80,sortable:true,hidden:true},
				  {field:'TRecLocId',title:'TRecLocId',width:80,sortable:true,hidden:true},
				  {field:'InstrTimeFrom',title:'开始时间',width:100,sortable:true},
				  {field:'InstrTimeTo',title:'结束时间',width:100,sortable:true},
				  {field:'InstrHospitalDR',title:'医院',width:200,sortable:true},
				  {field:'InstrOrdPrior',title:'医嘱优先级',width:100,sortable:true}
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
							width: windowWidth-200,    
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
			reclocurl += "&MWToken="+websys_getMWToken()
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
			content:"<iframe scrolling='auto' frameborder='0' width='100%' height='100%' iconCls='icon-w-home' src='"+reclocurl+"'></iframe>"
		});
	
	});	

	//重置
	$("#btnClear").click(function(e) {
		$('#itemcatgrid').datagrid('clearSelections');
		$('#locgrid').datagrid('clearSelections');		
		$('#selecteditemcatgrid').datagrid('loadData', { total: 0, rows: [] });			
		$('#patlocgrid').datagrid('loadData', { total: 0, rows: [] });	
		$('#reclocgrid').datagrid('loadData', { total: 0, rows: [] });
		
		$('#OECOrderCategory').combobox('setValue',"");	//置空医嘱大类
		$("#ItemCatDesc").searchbox('setValue', '');			//置空医嘱子类描述
		$('#LocGroup').combobox('setValue',"");	//置空科室组
		$('#InstrHospitalDR').combobox('setValue',"");	//置空医院
		$("#LocDesc").searchbox('setValue', '');			//置空科室描述
		
		//$('#Instruct').combobox('setValue',"");	//置空用法
		$('#InstrOrdPrior').combobox('setValue',"");	//置空医嘱优先级

		$('#InstrTimeFrom').timespinner('setValue',"");			
		$('#InstrTimeTo').timespinner('setValue',"");	
		$HUI.checkbox("#InstrDefault").setValue(false);
		
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

	
	//添加到检查表里  
	AddToList=function() {
		$('#creategrid').datagrid('loadData', { total: 0, rows: [] });
		
		var Instruct=$('#Instruct').combobox('getText');
		var InstrHospitalDR=$('#InstrHospitalDR').combobox('getText');
		var InstrOrdPrior=$('#InstrOrdPrior').combobox('getText');	//获取医嘱优先级
		
		var SelCatSubStr=GetData("selecteditemcatgrid");
    var HospCatStr=GetHosp("selecteditemcatgrid")

		var HospPatLocStr=GetHosp("patlocgrid")
		var PatLocStr=GetData("patlocgrid");
		var RecLocStr=GetData("reclocgrid");
		var SelCatSubIdStr=GetDataId("selecteditemcatgrid");		
		var PatLocIdStr=GetDataId("patlocgrid");
		var RecLocIdStr=GetDataId("reclocgrid");
		
	  	var InstrTimeFrom = $('#InstrTimeFrom').timespinner('getValue');

		var InstrTimeTo = $('#InstrTimeTo').timespinner('getValue');
		var ruleflag=1;	
		
		var selrow=$('#selecteditemcatgrid').datagrid("getRows");
		var patrow=$('#patlocgrid').datagrid("getRows");
		var recrow=$('#reclocgrid').datagrid("getRows");
		
		if((Instruct=="undefined")||(Instruct=="")){
			$.messager.alert('提示',"请选择用法!","info");
	  		
	  		return false;
		 }

		/*if(selrow.length==0){ 								 
			$.messager.alert('提示',"请选择医嘱子类!","info");
	  		return false;
		 }*/
		 if(recrow.length==0){
			$.messager.alert('提示',"请选择接收科室!","info");
	  		return false;
		 }
   		if (((InstrTimeFrom=="")&&(InstrTimeTo != ""))||((InstrTimeFrom!="")&&(InstrTimeTo== ""))) 
   		{
   			$.messager.alert('提示',"开始时间和结束时间需同时填写!","info");
        				
          	return;
   		}
   			 	
	 	if ((InstrTimeFrom!="")&&(InstrTimeTo != "")) {
	 		
	 		if (InstrTimeFrom>=InstrTimeTo) {
	 			$.messager.alert('提示',"结束时间必须大于开始时间!","info");			
			 	return;
			}
	 	}
	 	
		var InstrDefault=$('#InstrDefault').checkbox('getValue');
		if(InstrDefault==true){
			InstrDefault="Y";
		}
		else{
			InstrDefault="N";
		}
		var SelCatSubStrArry=SelCatSubStr.split("^");
		var PatLocStrArry=PatLocStr.split("^");
		var RecLocStrArry=RecLocStr.split("^");
		var HospCatArry=HospCatStr.split("^");
		var HospPatLocArry=HospPatLocStr.split("^");
		
		var SelCatSubIdArry=SelCatSubIdStr.split("^");
		var PatLocIdArry=PatLocIdStr.split("^");
		var RecLocIdArry=RecLocIdStr.split("^");
		if (InstrDefault=="Y") {
			if ((RecLocStrArry.length!=2)) {
				$.messager.alert('提示',"接收科室只可为一!","info");
				return;
			}
		}
		
		
		if(ruleflag==1){		
							//	多对多
			if(PatLocStrArry.length==1){
				PatLocStrArry.length=2;
			}
			if (SelCatSubStr=="")	//医嘱子类为空
			{
				var SelCatSub="";
			   	var SelCatSubId=""         
      			var HospCat=""
				for(var j=1;j<PatLocStrArry.length;j++){
      				var HospPat=HospPatLocArry[j];
					var SameHosp="是"
					
					var PatLoc=PatLocStrArry[j];
					var	PatLocId=PatLocIdArry[j];
					for(var k=1;k<RecLocStrArry.length;k++){
						var	RecLoc=RecLocStrArry[k];
						var	RecLocId=RecLocIdArry[k];
						
						$('#creategrid').datagrid('appendRow',{	
								Instruct:Instruct,
								SelCatSub: SelCatSub,
								PatLoc:PatLoc,
								RecLoc:RecLoc,
              					SameHosp:SameHosp,
								InstrDefault:InstrDefault,								
								TCatSubId:SelCatSubId,
								TPatLocId:PatLocId,
								TRecLocId:RecLocId,
								InstrHospitalDR:InstrHospitalDR,
								InstrOrdPrior:InstrOrdPrior,
								InstrTimeFrom:InstrTimeFrom,
								InstrTimeTo:InstrTimeTo
						})
					}	
				}
			}
			else
			{
				for(var i=1;i<SelCatSubStrArry.length;i++)
				{	
					
						var SelCatSub=SelCatSubStrArry[i];
					   	var SelCatSubId=SelCatSubIdArry[i]         
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
										Instruct:Instruct,
										SelCatSub: SelCatSub,
										PatLoc:PatLoc,
										RecLoc:RecLoc,
	                  					SameHosp:SameHosp,
										InstrDefault:InstrDefault,								
										TCatSubId:SelCatSubId,
										TPatLocId:PatLocId,
										TRecLocId:RecLocId,
										InstrHospitalDR:InstrHospitalDR,
										InstrOrdPrior:InstrOrdPrior,
										InstrTimeFrom:InstrTimeFrom,
										InstrTimeTo:InstrTimeTo
								})
							}	
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
		var Instruct=$('#Instruct').combobox('getText');
		var InstructId=$('#Instruct').combobox('getValue');

		var InstrOrdPrior=$('#InstrOrdPrior').combobox('getValue');
        var InstrHospitalDR=$('#InstrHospitalDR').combobox("getValue");
        var InstrTimeFrom=$('#InstrTimeFrom').timespinner('getValue');	
        var InstrTimeTo=$('#InstrTimeTo').timespinner('getValue');
        var InstrDefault=$('#InstrDefault').checkbox('getValue');
		if(InstrDefault==true){
			InstrDefault="1";
		}
		else{
			InstrDefault="0";
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
			var str=InstrOrdPrior+"^"+InstrTimeFrom+"~"+InstrTimeTo+"^"+InstrHospitalDR
			var flag=tkMakeServerCall("web.DHCBL.CT.DHCPHCInstrRecLoc","FormValidate","",InstructId,PatLocId,RecLocId,SelCatSubId,str);
			var WarningMsg="";
			var flag2=0;
			if(InstrDefault=="1"){
		 		flag2=tkMakeServerCall("web.DHCBL.CT.DHCPHCInstrRecLoc","GetDefRecLoc",InstructId,"",PatLocId,SelCatSubId,str);
		 						
		 		if (flag2==1)
		 		{
		 			WarningMsg='已经存在默认规则!'
		 		}
		 		else if (flag2==2)
		 		{
		 			WarningMsg='医嘱子类与病人科室不在同一个医院组!'
		 		}

	 		} 
	 		var Data=SelCatSub+"#"+Instruct+"#"+PatLoc+"#"+RecLoc;
	 		var Tips="";	
			if(flag!=1){
				if (flag==2)
				{
					Tips='医嘱子类与病人科室不在同一个医院组!'
				}else{
					Tips="【"+SelCatSub+"】的用法"+"【"+Instruct+"】"+"未维护科室为"+"【"+PatLoc+"】到:【"+RecLoc+"】"+"的接收科室";
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
		var InstructId=$('#Instruct').combobox('getValue');
		for(var i=0;i<rows.length;i++){

			var Instruct=rows[i].Instruct;
			var SelCatSub=rows[i].SelCatSub;	
			var RecLoc=rows[i].RecLoc;	
			var PatLoc=rows[i].PatLoc;			
			var RLRowId="";
			var TCatSubId=rows[i].TCatSubId;
			var InstrOrdDep=rows[i].TPatLocId;
			var InstrRecLoc=rows[i].TRecLocId;
			
			var InstrDefault=rows[i].InstrDefault;
			if(InstrDefault=="Y"){
				InstrDefault=1;
			}
			else{
				InstrDefault=0;
			}
			if(InstrOrdDep==undefined){										
				InstrOrdDep="";
			}
			if(PatLoc==undefined){										
				PatLoc="";
			}
			var InstrHospitalDR=$('#InstrHospitalDR').combobox('getValue');
			var InstrTimeFrom=rows[i].InstrTimeFrom;
			var InstrTimeTo=rows[i].InstrTimeTo;
			var InstrOrdPrior=$('#InstrOrdPrior').combobox('getValue');		
			var InstrTimeRange=InstrTimeFrom+"~"+InstrTimeTo
			var strs=InstrOrdPrior+"^"+InstrTimeRange+"^"+InstrHospitalDR
			var flag=0;
			if (InstrDefault=="1"){
				flag=tkMakeServerCall("web.DHCBL.CT.DHCPHCInstrRecLoc","GetDefRecLoc",InstructId,"",InstrOrdDep,TCatSubId,strs);
			}																
			
			if (flag==1){
				$('#resultgrid').datagrid('appendRow',{			
					Data: Instruct+"#"+SelCatSub+"#"+PatLoc+"#"+RecLoc,
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
			var str='{"InstrRecLocParRef":"'+InstructId+'","RowID":"","InstrOrdDep":"'+InstrOrdDep+'","InstrRecLoc":"'+InstrRecLoc+'","InstrOrdSubCat":"'+TCatSubId+'","InstrDefault":"'+
			InstrDefault+'","InstrHospitalDR":"'+InstrHospitalDR+'","InstrTimeRange":"'+InstrTimeRange+'","InstrOrdPrior":"'+InstrOrdPrior+'"}';
			var strobj=eval('('+str+')');

			$.ajax({
					url:SAVE_ACTION_URL,  
					data:strobj,  
					type:"POST",   										
                    success: function (data) {
                    	var data=eval('('+data+')'); 
						if(data.success == 'true'){
							$('#resultgrid').datagrid('appendRow',{	
								Data: data.InstrOrdSubCatDesc+"#"+data.InstructDesc+"#"+data.InstrOrdDepDesc+"#"+data.InstrRecLocDesc,
								Tips:"保存成功！"								
							});	
						}
						else{							
							$('#resultgrid').datagrid('appendRow',{			
								Data: data.InstrOrdSubCatDesc+"#"+data.InstructDesc+"#"+data.InstrOrdDepDesc+"#"+data.InstrRecLocDesc,
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
	
	
				
}
 $(init);