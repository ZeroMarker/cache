
//Creator:陈莹
//CreatDate:2018-2-5	
//Description:节假日 hisui

var init = function(){
	
	var HospID=""
	var DateFormat=tkMakeServerCall("web.DHCBL.BDP.FunLib","DateFormat");
	
	//多院区下拉框
	var hospComp=GenHospComp('BDP_Holiday');
	hospComp.options().onSelect=function(){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		ClearFunLib();
	}
	
	/*var KEY = { SHIFT: 16, CTRL: 17, ALT: 18, DOWN: 40, RIGHT: 39, UP: 38, LEFT: 37 };
    var selectIndexs = { firstSelectRowIndex: 0, lastSelectRowIndex: 0 };
    var inputFlags = { isShiftDown: false, isCtrlDown: false, isAltDown: false };
    var grid=""
	
	$(document).ready(function () {
        $("body")[0].onkeydown = keyPress;
        $("body")[0].onkeyup = keyRelease;
    });

    function keyPress(event) {//响应键盘按下事件
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
	
	function keyRelease(event) { //响应键盘按键放开的事件
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
	*/
	var Type="",IEFlag="";
	var TimeRangeFlag="N";
	///时段   存在问题，一开始为空时，点击一个时段  显示为  ,时段1
	////$('#BDPHSTimeRangeDR').combobox({ 
	var BDPHSTimeRangeDR =$HUI.combobox("#BDPHSTimeRangeDR",{
		url:$URL+"?ClassName=web.DHCBL.CT.BDPHolidayService&QueryName=GetRangeDataForCmb&ResultSetType=array",
		multiple:true,
		valueField:'TRRowId',
		textField:'TRDesc',
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false
	});
	
	//↓检索工具条
	$('#TextBDPHSServiceDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.BDPSpecialService&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'BDPSSRowId',
		textField:'BDPSSDesc',
		onSelect:function(record){
			$.m({
				ClassName:"web.DHCBL.CT.BDPHolidayService",
				MethodName:"IsShowTimeRange",
				'serviceid':record.BDPSSRowId
			},function(txtData){
				if (txtData=="Y")
				{    
				   TimeRangeFlag="Y";
		           $("#holidaygrid").datagrid("showColumn", "BDPHSTimeRangeDR"); // 设置隐藏列
		           $("#weekendgrid").datagrid("showColumn", "BDPHSTimeRangeDR"); // 设置隐藏列  
		        }
		        else
		        {
		        	TimeRangeFlag="N";
		        	$("#holidaygrid").datagrid("hideColumn", "BDPHSTimeRangeDR"); // 设置隐藏列   
		        	$("#weekendgrid").datagrid("hideColumn", "BDPHSTimeRangeDR"); // 设置隐藏列   
		        }
		        SearchFunLib();
			})
		},
		onChange:function(newValue, oldValue){
			if(newValue=="")
			{
				TimeRangeFlag="N";
			    $("#holidaygrid").datagrid("hideColumn", "BDPHSTimeRangeDR"); // 设置隐藏列   
			    $("#weekendgrid").datagrid("hideColumn", "BDPHSTimeRangeDR"); // 设置隐藏列   
			    
			    SearchFunLib();
				
			}
		}
	});
  /*
	//节假日放假的类型  （重医附一 2022-03-28 ，节日全天QT，节日半天BT，节日放假FJ
	$('#BDPHDHolidayType').combobox({ 
		data:[{'value':'QT','text':'节日全天'},{'value':'BT','text':'节日半天'},{'value':'FJ','text':'节日放假'}],
        valueField:'value',
        textField:'text'
	});
	*/
	
	ResetDate=function(addyear)
	{
		if (DateFormat=="3")   //Y-M-D
		{
			$('#StartDate').datebox('setValue', ((new Date()).getFullYear()+addyear)+'-01-01');	// 给日期框赋值
			$('#EndDate').datebox('setValue', ((new Date()).getFullYear()+addyear)+'-12-31');	// 给日期框赋值
		}
		else
		{   //j/n/Y
			$('#StartDate').datebox('setValue', '01/01/'+((new Date()).getFullYear()+addyear));	// 给日期框赋值
			$('#EndDate').datebox('setValue', '31/12/'+((new Date()).getFullYear()+addyear));	// 给日期框赋值
		}
	}
	
	$HUI.radio("[name='SelectYear']",{
        onChecked:function(e,value){
           if ($(e.target).attr("value")=='thisyear')  //选择今年
           {
           		ResetDate(0)
           }
           if ($(e.target).attr("value")=='nextyear')  //选择明年
           {
		       ResetDate(1)
           		
           }
		 
       }
    });
	//查询按钮
	$("#btnSearch").click(function (e) { 
			SearchFunLib();
	 })  
	 
	//重置按钮
	$("#btnRefresh").click(function (e) 
	{ 
			ClearFunLib();
	}) 
	//页面帮助按钮
	$("#btnHelp").click(function (e) { 
			$("#myHelpWin").show();
			var myhelpwin = $HUI.dialog("#myHelpWin",{
					iconCls:'icon-w-paper',
					resizable:true,
					title:'页面帮助',
					modal:true
				});	
	 })  
	//查询方法
	function SearchFunLib(){
		var onlyweekendflag=($('#onlyweekendflag').checkbox('getValue')==true?'Y':'N')  //获取复选框控件的值
		var datefrom=$('#StartDate').datebox('getValue');    //获取日期控件的值
		var dateto=$('#EndDate').datebox('getValue');    //获取日期控件的值
		var servicedr=$('#TextBDPHSServiceDR').combobox('getValue')   //获取下拉框控件当前选中的值
		
		if (servicedr=="")
		{
			$('#include_btn_holiday').hide();
			$('#exclude_btn_holiday').hide();
			$('#include_btn_weekend').hide();
			$('#exclude_btn_weekend').hide();
		}
		else
		{
			$('#include_btn_holiday').show();
			$('#exclude_btn_holiday').show();
			$('#include_btn_weekend').show();
			$('#exclude_btn_weekend').show();
		}
		if((datefrom=="")||(dateto==""))
		{
			$.messager.alert('错误提示','请选择开始日期和结束日期!',"error");
			return;
		}
		//待选日期列表
		$('#mygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetAllDayList"	,	
			'datefrom':datefrom,	
			'dateto': dateto
			,'onlyweekendflag':onlyweekendflag,
			'servicedr':servicedr,
			rows:10000,
			hospid:hospComp.getValue()
		});
		$('#mygrid').datagrid('unselectAll');
		
		///节日列表
		$('#holidaygrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetHWList",
			'Type':"Holiday",
			'datefrom':datefrom,	
			'dateto': dateto,
			'servicedr':servicedr,
			rows:10000,
			hospid:hospComp.getValue()
		});
		$('#holidaygrid').datagrid('unselectAll');
		
		//假日列表
		$('#weekendgrid').datagrid('load',  { 
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetHWList",	
			'Type':"Weekend",
			'datefrom':datefrom,	
			'dateto': dateto,
			'servicedr':servicedr,
			rows:10000,
			hospid:hospComp.getValue()
		});
		$('#weekendgrid').datagrid('unselectAll');

	}
	
	//重置方法
	function ClearFunLib()
	{
		$HUI.radio("#year1").setValue(true);  //选择今年
		ResetDate(0);  //重置查询框上的开始日期 结束日期
		$('#TextBDPHSServiceDR').combobox('setValue', '')
		$HUI.checkbox("#onlyweekendflag").setValue(false);
		var datefrom=$('#StartDate').datebox('getValue');    //获取日期控件的值
		var dateto=$('#EndDate').datebox('getValue');    //获取日期控件的值
		var servicedr="";
		var onlyweekendflag="";
		if((datefrom=="")||(dateto==""))
		{
			$.messager.alert('错误提示','请选择开始日期和结束日期!',"error");
			return;
		}
		
		//延迟加载 2022-12-20
		setTimeout(function () {
					
			//待选日期列表
			$('#mygrid').datagrid('load',  { 
				ClassName:"web.DHCBL.CT.BDPHoliday",
				QueryName:"GetAllDayList"	,	
				'datefrom':datefrom,	
				'dateto': dateto
				,'onlyweekendflag':onlyweekendflag,
				'servicedr':servicedr,
				rows:10000,
				hospid:hospComp.getValue()
			});
			$('#mygrid').datagrid('unselectAll');
			
			///节日列表
			$('#holidaygrid').datagrid('load',  { 
				ClassName:"web.DHCBL.CT.BDPHoliday",
				QueryName:"GetHWList",
				'Type':"Holiday",
				'datefrom':datefrom,	
				'dateto': dateto,
				'servicedr':servicedr,
				rows:10000,
				hospid:hospComp.getValue()
			});
			$('#holidaygrid').datagrid('unselectAll');
			
			//假日列表
			$('#weekendgrid').datagrid('load',  { 
				ClassName:"web.DHCBL.CT.BDPHoliday",
				QueryName:"GetHWList",	
				'Type':"Weekend",
				'datefrom':datefrom,	
				'dateto': dateto,
				'servicedr':servicedr,
				rows:10000,
				hospid:hospComp.getValue()
			});
			$('#weekendgrid').datagrid('unselectAll');
		}, 10); //0.01s
	}
	
	
	
	//↓待选日期列表
	 $HUI.checkbox("[name='onlyweekendflag']",{
        onChecked:function(e,value){
			var datefrom=$('#StartDate').datebox('getValue');    //获取日期控件的值
			var dateto=$('#EndDate').datebox('getValue');    //获取日期控件的值
			$('#mygrid').datagrid('load',  { 
				ClassName:"web.DHCBL.CT.BDPHoliday",
				QueryName:"GetAllDayList"	,	
				'datefrom':datefrom,	
				'dateto': dateto,
				'onlyweekendflag':"Y",
				rows:10000,
				hospid:hospComp.getValue()
			});
			$('#mygrid').datagrid('unselectAll');
		 
       },
       onUnchecked:function(e,value){
			var datefrom=$('#StartDate').datebox('getValue');    //获取日期控件的值
			var dateto=$('#EndDate').datebox('getValue');    //获取日期控件的值
			$('#mygrid').datagrid('load',  { 
				ClassName:"web.DHCBL.CT.BDPHoliday",
				QueryName:"GetAllDayList"	,	
				'datefrom':datefrom,	
				'dateto': dateto,
				'onlyweekendflag':"",
				rows:10000,
				hospid:hospComp.getValue()
			});
			$('#mygrid').datagrid('unselectAll');
		 
       }
    });
       
    
    
	//新增到节日按钮
	$("#addH_btn").click(function (e) 
	{ 
		Type="Holiday",IEFlag="Include";
		MultiAdd();
	}) 
	//新增到假日按钮
	$("#addW_btn").click(function (e) 
	{ 
		Type="Weekend",IEFlag="Include";  //默认包含
		MultiAdd();
	}) 
	
	
	//新增到节日、假日方法
	function MultiAdd(){
		//var row = $("#mygrid").datagrid("getSelected");   //取得第一个选中行数据，如果没有选中行，则返回 null，否则返回记录。
		//$('#mygrid').datagrid('selectRow',0);//grid加载完成后自动选中第一行
		var rows = $('#mygrid').datagrid('getSelections');  //取得所有选中行数据，返回元素记录的数组数据
		
		if(rows.length>0)
		{
			var ErrorFlag=0;
			var errorMsg ="提交失败！"
			var servicedr=$('#TextBDPHSServiceDR').combobox('getValue')   //获取下拉框控件当前选中的值
			if (servicedr>0)
			{
				var SaveData_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHolidayService&pClassMethod=SaveData";
				for(var i=0; i<rows.length; i++){
					var DataStr=""+"^"+rows[i].myDate+"^"+Type +"^"+servicedr+"^"+IEFlag+"^" +"^"+"^"+hospComp.getValue();  //1 rowid  2日期 YYYY-MM-DD  3 类型Holiday   4特殊业务rowid   5BDPHSIEFlag   6描述  7时段
					$.ajax({
						url:SaveData_ACTION_URL,  
						data:{DataStr:DataStr},  
						type:"POST",   
						success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success != 'true') 
							  {
								  	var ErrorFlag=1
								  	if (data.errorinfo) {
								  		errorMsg=errorMsg+","+data.errorinfo
								  	}
								  	
							 }			
						}  
					})
				}
				
				
			}
			else{
				
				var SaveData_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHoliday&pClassMethod=SaveData";
				for(var i=0; i<rows.length; i++){
					var DataStr=""+"^"+rows[i].myDate+"^"+Type+"^"+"^"+hospComp.getValue();    //1 rowid  2日期 YYYY-MM-DD  3 类型Holiday
					/*存在全部保存完之前提前刷新的情况
					$.ajax({
						url:SaveData_ACTION_URL,  
						data:{DataStr:DataStr},  
						type:"POST",   
						success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success != 'true') 
							  {
								  	var ErrorFlag=1
								  	if (data.errorinfo) {
								  		errorMsg=errorMsg+","+data.errorinfo
								  	}
								  	
							 }			
						}  
					})
					*/
					//换tkMakeServerCall速度稍慢，但能在全部保存完后再刷新
					var resultMsg=tkMakeServerCall("web.DHCBL.CT.BDPHoliday","SaveData",DataStr);
					resultMsg=eval('('+resultMsg+')');
					//alert(resultMsg.success);
					if (resultMsg.success != 'true') 
					{
							ErrorFlag=1
							if (resultMsg.errorinfo) {
								errorMsg=errorMsg+","+resultMsg.errorinfo
							}
					}
				}
			}
			
			if (ErrorFlag==0)
			{
				
				$('#mygrid').datagrid('reload');  // 重新载入当前页面数据  
				$('#holidaygrid').datagrid('reload');  // 重新载入当前页面数据 
				$('#weekendgrid').datagrid('reload');  // 重新载入当前页面数据 
				$('#mygrid').datagrid('unselectAll');
				$('#holidaygrid').datagrid('unselectAll');
				$('#weekendgrid').datagrid('unselectAll');
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
				/*
				setTimeout(function () {
					SearchFunLib();
				}, 10); //0.01s
				*/
			}
			else
			{
				 $.messager.alert('操作提示',errorMsg,"error");
			}
			
			
		}
		else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
	}
	
	
	var columns =[[  
	 			  {field:'myDate',title:'日期',width:180},
				  {field:'Weekendflag',title:'是否周末',width:180,formatter:ReturnFlagIcon}
				  ]];
				  
				  
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		queryParams:{
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetAllDayList",
			rows:10000,
			hospid:hospComp.getValue()
		},
		columns: columns,  //列信息
		striped:true,//设置为 true，则把行条纹化。（即奇偶行使用不同背景色）  默认为false
		
		//pageSize:10,
		//pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:false,
		frozenColumns:[[ {field:'ck',checkbox:true}]],//多选框,位置固定在最左边
		idField:'myDate',   //标识字段
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		toolbar:'#mytbar'
	});
	
	function GridLoadSuccess(data,gridid)
	{
		var panel = $("#"+gridid).datagrid('getPanel');   
        var tr = panel.find('div.datagrid-view2 div.datagrid-body tr');    
        tr.each(function(){   
        	
            var td = $(this).children('td[field="BDPHSIEFlag"]');   
            var textValue = td.children("div").text();   
           if(textValue == 'Include'){  
                  /* $(this).css({     
                        "background-color":"#B8EB8A"  
                   });*/
                 
                  $(this).children('td[field="BDPHDDate"]').append('<span class="l-btn-icon ieflag icon-include" style="position: absolute; top: 0px;left: 100px;">&nbsp;</span>')
                  $(this).children('td[field="BDPHDDate"]').addClass('relativeposi')
											
            };   
             if(textValue == 'Exclude'){  
            	/*$(this).css({     
                    "background-color":"#FF2929"
               }); */
             
               $(this).children('td[field="BDPHDDate"]').append('<span class="l-btn-icon ieflag icon-exclude" style="position: absolute; top: 0px;left: 100px;">&nbsp;</span>')
               $(this).children('td[field="BDPHDDate"]').addClass('relativeposi')
            
            }; 
            
		   
		   
        });
	}
	
	var columns =[[ 
				  {field:'BDPHDDate',title:'日期',width:180},
				  {field:'BDPHDDesc',title:'描述',width:180}, 
				  {field:'BDPHDRowId',title:'BDPHDRowId',width:120,hidden:true}
				  ,{field:'BDPHSRowId',title:'BDPHSRowId',width:120,hidden:true}
				  ,{field:'BDPHSIEFlag',title:'包含例外类型',width:120,hidden:true}
				  ,{field:'TimeRangeFlag',title:'时段标志',width:120,hidden:true}
				  ,{field:'BDPHSTimeRangeDRID',title:'时段ID',width:120,hidden:true}
				  ,{field:'BDPHSTimeRangeDR',title:'时段',width:240,hidden:true}
				 
				  ]];
	//↓已选节日列表
	var holidaygrid = $HUI.datagrid("#holidaygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetHWList",
			rows:10000,
			hospid:hospComp.getValue()
		},
		columns: columns,  //列信息
		pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		///pageSize:10,
		///pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true, 
		//idField:'BDPHDRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
		//toolbar:'#mytbar'
		onLoadSuccess:function(data){ 
				 GridLoadSuccess(data,"holidaygrid") 
        },
        onDblClickRow:function(rowIndex,rowData){
        	
        	Type="Holiday"
			UpdateData(holidaygrid)
        },
		onClickRow:function(index,row){
        	/*grid="holidaygrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#holidaygrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#holidaygrid').datagrid('selectRow', i);
	            }
	        }*/
        },
		toolbar:[{
			
			iconCls:'icon-write-order',
			text:'修改',
			id:'update_btn_holiday',
			handler:function()
			{
				Type="Holiday"
				UpdateData(holidaygrid)
			}
		},{
			iconCls:'icon-cancel',
			text:'删除',
			id:'del_btn_holiday',
			handler:function()
			{
				DelData(holidaygrid)
			}
		/*},{
			iconCls:'icon-include',
			text:'包含',
			id:'include_btn_holiday',
			handler:function()
			{
				Type="Holiday",IEFlag="Include"
				SaveHolidayService(holidaygrid)
			}*/
		},{
			iconCls:'icon-exclude',
			text:'例外',
			id:'exclude_btn_holiday',
			handler:function()
			{
				Type="Holiday",IEFlag="Exclude"
				SaveHolidayService(holidaygrid)
			}
		
		}]
	});
	
	//↓已选假日列表
	
	var weekendgrid = $HUI.datagrid("#weekendgrid",{
		url:$URL,
		width:500,
		queryParams:{
			ClassName:"web.DHCBL.CT.BDPHoliday",
			QueryName:"GetHWList",
			rows:10000,
			hospid:hospComp.getValue()
		},
		columns: columns,  //列信息
		///pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		///pageSize:10,
		///pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		//idField:'BDPHDRowId', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		//remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
		//toolbar:'#mytbar'
		onLoadSuccess:function(data){
			 GridLoadSuccess(data,"weekendgrid") 
        },
        onDblClickRow:function(rowIndex,rowData){
        	
        	Type="Weekend"
			UpdateData(weekendgrid)
        },
		onClickRow:function(index,row){
        	/*grid="weekendgrid"
        	if (index != selectIndexs.firstSelectRowIndex && !inputFlags.isShiftDown) {
	            selectIndexs.firstSelectRowIndex = index; //alert('firstSelectRowIndex, sfhit = ' + index);
	        }
	        if (inputFlags.isShiftDown) {
	            $('#weekendgrid').datagrid('clearSelections');
	            selectIndexs.lastSelectRowIndex = index;
	            var tempIndex = 0;
	            if (selectIndexs.firstSelectRowIndex > selectIndexs.lastSelectRowIndex) {
	                tempIndex = selectIndexs.firstSelectRowIndex;
	                selectIndexs.firstSelectRowIndex = selectIndexs.lastSelectRowIndex;
	                selectIndexs.lastSelectRowIndex = tempIndex;
	            }
	            for (var i = selectIndexs.firstSelectRowIndex ; i <= selectIndexs.lastSelectRowIndex ; i++) {
	                $('#weekendgrid').datagrid('selectRow', i);
	            }
	        }*/
        },
		toolbar:[{
			
			iconCls:'icon-write-order',
			text:'修改',
			id:'update_btn_weekend',
			handler:function()
			{
				Type="Weekend"
				UpdateData(weekendgrid)
			}
		},{
			iconCls:'icon-cancel',
			text:'删除',
			//disabled:true,
			id:'del_btn_weekend',
			handler:function()
			{
				DelData(weekendgrid)
			}
		/*},{
			iconCls:'icon-include',
			text:'包含',
			id:'include_btn_weekend',
			handler:function()
			{
				Type="Weekend",IEFlag="Include"
				SaveHolidayService(weekendgrid)
			}*/
		},{
			iconCls:'icon-exclude',
			text:'例外',
			id:'exclude_btn_weekend',
			handler:function()
			{
				Type="Weekend",IEFlag="Exclude"
				SaveHolidayService(weekendgrid)
			}
		}]
	});
	
	function SaveHolidayService(grid)
	{
			
			var servicedr=$('#TextBDPHSServiceDR').combobox('getValue')   //获取下拉框控件当前选中的值
			if (servicedr>0)
			{
				var record = grid.getSelected(); 
				if (record){
						if (IEFlag=="Exclude")
						{
							if (record.BDPHDRowId=="")
							{
								$.messager.alert('操作提示',"只能对公共节假日设置例外状态！","error");
								return;
							}
						}
						var SaveData_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHolidayService&pClassMethod=SaveData";
						var DataStr=record.BDPHSRowId+"^"+record.BDPHDDate+"^"+Type+"^"+$('#TextBDPHSServiceDR').combobox('getValue')+"^"+IEFlag+"^"+record.BDPHDDesc+"^"+record.BDPHSTimeRangeDRID+"^"+hospComp.getValue();  //1 rowid  2日期 YYYY-MM-DD  3 类型Holiday   4特殊业务rowid   5BDPHSIEFlag   6描述   7 时段id
						//alert(DataStr)
						$.ajax({
							url:SaveData_ACTION_URL,  
							data:{DataStr:DataStr},  
							type:"POST",   
							success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') 
								  {
								  		$('#mygrid').datagrid('reload');  // 重新载入数据  
										$('#holidaygrid').datagrid('reload');  // 重新载入数据
										$('#weekendgrid').datagrid('reload');  // 重新载入数据
										$('#mygrid').datagrid('unselectAll');
										$('#holidaygrid').datagrid('unselectAll');
										$('#weekendgrid').datagrid('unselectAll');
										$('#myWinService').dialog('close'); // close a dialog
										
										$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								
										
										
								  } 
								  else
								  {
									  	var errorMsg ="提交失败！"
										if (data.errorinfo) {
											errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
										}
										$.messager.alert('操作提示',errorMsg,"error");
									  	
								 }			
							}  
						})
						
				}else{
					$.messager.alert('错误提示','请先选择一条记录!',"error");
				}
			}
			else{
					$.messager.alert('错误提示','请先选择特殊业务!',"error");
			}	
			IEFlag=""
	}
	 //点击新增按钮
	function AddData() {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		
		
		
	}
	
	//点击修改按钮
	function UpdateData(grid) {
		var record = grid.getSelected();
		if (record){
			if (grid.getSelections().length!=1)
			{
				$.messager.alert('错误提示','只能选择一条记录修改!',"error");
				return;
			}
			if (record.BDPHSRowId!="")
			{
				//判断是否显示时段下拉框
				$.m({
					ClassName:"web.DHCBL.CT.BDPHolidayService",
					MethodName:"IsShowTimeRange",
					'serviceid':$('#TextBDPHSServiceDR').combobox('getValue')
				},function(txtData){
					if (txtData=="Y")
					{
						$("#BDPHSTimeRangeDRtr").show()
					}
					else{
						$("#BDPHSTimeRangeDRtr").hide()
					}
						
					
				});
						
						
				//调用后台openData方法给表单赋值
				var id = record.BDPHSRowId;
				$.cm({
					ClassName:"web.DHCBL.CT.BDPHolidayService",
					MethodName:"OpenData",
					id:id,
					RetFlag:'JSON'
				},function(jsonData){
					
					if ((jsonData.BDPHSTimeRangeDR).indexOf(",")<1)
					{
						$('#BDPHSTimeRangeDR').combobox('setValue', jsonData.BDPHSTimeRangeDR);
					}
					else
					{
						$('#BDPHSTimeRangeDR').combobox('setValues',(jsonData.BDPHSTimeRangeDR).split(","));

					}
					
					
					$('#form-saveService').form("load",jsonData);	
					$("#myWinService").show();
				
					var myWinService = $HUI.dialog("#myWinService",{
						iconCls:'icon-w-edit',
						resizable:true,
						title:'修改',
						modal:true,
						buttons:[{
							text:'保存',
							id:'save_btn',
							handler:function(){
								SaveFunLibService(id,grid)
							}
						},{
							text:'关闭',
							handler:function(){
								myWinService.close();
							}
						}]
					});	
					
					
				});
			
			}
			else
			{
				
				if ($('#TextBDPHSServiceDR').combobox('getValue')!="")
				{
					//调用后台openData方法给表单赋值
					var id = record.BDPHDRowId;
					$.cm({
						ClassName:"web.DHCBL.CT.BDPHolidayService",
						MethodName:"NewOpenData2",
						id:id
					},function(jsonData){
						$('#BDPHSTimeRangeDR').combobox('setValue', "");
						
						$('#form-saveService').form("load",jsonData);
						$("#myWinService").show();
					
						var myWinService = $HUI.dialog("#myWinService",{
							iconCls:'icon-w-edit',
							resizable:true,
							title:'修改',
							modal:true,
							buttons:[{
								text:'保存',
								id:'save_btn',
								handler:function(){
									SaveFunLibService("",grid)
								}
							},{
								text:'关闭',
								handler:function(){
									myWinService.close();
								}
							}]
						});
					});
					
					
							
					
				}
				else
				{
					//调用后台openData方法给表单赋值
					var id = record.BDPHDRowId;
					
					$.cm({
						ClassName:"web.DHCBL.CT.BDPHoliday",
						MethodName:"OpenData",
						id:id,
						RetFlag:'JSON'
					},function(jsonData){
						
						$('#form-save').form("load",jsonData);	
					});
					
					$("#myWin").show(); 
					var myWin = $HUI.dialog("#myWin",{
						iconCls:'icon-w-edit',
						resizable:true,
						title:'修改',
						modal:true,
						buttons:[{
							text:'保存',
							id:'save_btn',
							handler:function(){
								SaveFunLib(id,grid)
							}
						},{
							text:'关闭',
							handler:function(){
								myWin.close();
							}
						}]
					});	
					
				}
			}
			
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	

	}
	///新增、修改
	function SaveFunLib(id)
	{ 
		if ($('#BDPHDDate').datebox('getValue')=="")
		{
			$.messager.alert('错误提示','日期不能为空!',"error");
			return;
		}
		if ($.trim($("#BDPHDDesc").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		
		var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.BDPHoliday&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.BDPHoliday";

		$('#form-save').form('submit', { 
			url: SAVE_ACTION_URL, 
			onSubmit: function(param){
				param.BDPHDRowId = id;
				param.LinkHospId = hospComp.getValue();
			},
			success: function (data) { 
			  var data=eval('('+data+')'); 
			  if (data.success == 'true') {
			  	$('#mygrid').datagrid('reload');  // 重新载入数据  
				$('#holidaygrid').datagrid('reload');  // 重新载入数据
				$('#weekendgrid').datagrid('reload');  // 重新载入数据
				$('#mygrid').datagrid('unselectAll');
				$('#holidaygrid').datagrid('unselectAll');
				$('#weekendgrid').datagrid('unselectAll');
				$('#myWin').dialog('close'); // close a dialog
				
				$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								
				
				
			  } 
			  else { 
				var errorMsg ="提交失败！"
				if (data.errorinfo) {
					errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
				}
				 $.messager.alert('操作提示',errorMsg,"error");
	
			}

			} 
		  }); 


	}
	///新增、修改
	function SaveFunLibService(id,grid)
	{ 
		if ($('#BDPHSDate').datebox('getValue')=="")
		{
			$.messager.alert('错误提示','日期不能为空!',"error");
			return;
		}
		if ($.trim($("#BDPHSDesc").val())=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		
		
		
		
		var servicedr=$('#TextBDPHSServiceDR').combobox('getValue')   //获取下拉框控件当前选中的值
		if (servicedr>0)
		{
			var record = grid.getSelected(); 
			if (record){
					if (IEFlag=="Exclude")
					{
						if (record.BDPHDRowId=="")
						{
							$.messager.alert('操作提示',"只能对公共节假日设置例外状态！","error");
							return;
						}
					}
					var SaveData_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHolidayService&pClassMethod=SaveData";
					IEFlag=record.BDPHSIEFlag
					if (IEFlag=="") IEFlag="Include"
					var DataStr=id+"^"+$('#BDPHSDate').datebox('getValue')+"^"+Type+"^"+$('#TextBDPHSServiceDR').combobox('getValue')+"^"+IEFlag+"^"+$.trim($("#BDPHSDesc").val())+"^"+BDPHSTimeRangeDR.getValues()+"^"+hospComp.getValue(); //    $('#Textb').val()  //1 rowid  2日期 YYYY-MM-DD  3 类型Holiday   4特殊业务rowid   5BDPHSIEFlag   6描述   7 时段id
					//alert(DataStr)
					$.ajax({
						url:SaveData_ACTION_URL,  
						data:{DataStr:DataStr},  
						type:"POST",   
						success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') 
							  {
							  		$('#mygrid').datagrid('reload');  // 重新载入数据  
									$('#holidaygrid').datagrid('reload');  // 重新载入数据
									$('#weekendgrid').datagrid('reload');  // 重新载入数据
									$('#holidaygrid').datagrid('unselectAll');  // 重新载入数据
									$('#weekendgrid').datagrid('unselectAll');
									$('#mygrid').datagrid('unselectAll');
									$('#myWinService').dialog('close'); // close a dialog
									$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
				
									
							  } 
							  else
							  {
								  	var errorMsg ="提交失败！"
									if (data.errorinfo) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
									}
									$.messager.alert('操作提示',errorMsg,"error");
								  	
							 }			
						}  
					})
			}else{
				$.messager.alert('错误提示','请先选择一条记录!',"error");
			}
		}
		else{
				$.messager.alert('错误提示','请先选择特殊业务!',"error");
		}	
		IEFlag=""
	}

	///删除
	function DelData(grid)
	{
		var datas = grid.getSelections();  //获取所有选中行
		if (datas==""){	
			$.messager.alert('错误提示','未选中要删除的行!',"error");
			return;
		}
		
		if ($('#TextBDPHSServiceDR').combobox('getValue')>0)
		{
			var inputstr="";
			for(var i=0; i<datas.length; i++) {   //循环获取选中数据
				if(datas[i].BDPHSRowId=="")
				{
					$.messager.alert('错误提示','选择特殊业务时不能删除公共节假日!',"error");
					return;
				}
				if (inputstr!="")
				{
					inputstr=inputstr+"^"
				}
				inputstr=inputstr+datas[i].BDPHSRowId
			}
			var DELETE_ACTION_URL_ALL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHolidayService&pClassMethod=DeleteAll";
			
		
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					//var id=row.BDPHSRowId;
					$.ajax({
						url:DELETE_ACTION_URL_ALL,  
						data:{"inputstr":inputstr},  
						type:"POST",   
						//dataType:"TEXT",  
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
								  		$('#mygrid').datagrid('reload');  // 重新载入数据  
										$('#holidaygrid').datagrid('reload');  // 重新载入数据
										$('#weekendgrid').datagrid('reload');  // 重新载入数据
										$('#mygrid').datagrid('unselectAll');
										$('#holidaygrid').datagrid('unselectAll');
										$('#weekendgrid').datagrid('unselectAll');
										$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
										
								  } 
								  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									$.messager.alert('操作提示',errorMsg,"error");
						
								}			
						}  
					})
				}
			})
		}
		else
		{
			var str="";
			for(var i=0; i<datas.length; i++) {   //循环获取选中数据
				if (str!="")
				{
					str=str+"^"
				}
				str=str+datas[i].BDPHDRowId
			}
			var DELETE_ACTION_URL_ALLD = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.BDPHoliday&pClassMethod=DeleteAll";
			$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){	
					//var id=row.BDPHDRowId;
					$.ajax({
						url:DELETE_ACTION_URL_ALLD,  
						data:{"str":str},  
						type:"POST",   
						//dataType:"TEXT",  
						success: function(data){
								  var data=eval('('+data+')'); 
								  if (data.success == 'true') {
									  	$('#mygrid').datagrid('reload');  // 重新载入数据  
										$('#holidaygrid').datagrid('reload');  // 重新载入数据
										$('#weekendgrid').datagrid('reload');  // 重新载入数据
										$('#mygrid').datagrid('unselectAll');
										$('#holidaygrid').datagrid('unselectAll');
										$('#weekendgrid').datagrid('unselectAll');
										$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
									
								  } 
								  else { 
									var errorMsg ="删除失败！"
									if (data.info) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.info
									}
									 $.messager.alert('操作提示',errorMsg,"error");
						
								}
						}  
					})
				}
			})
		}
	}
	
	$('#include_btn_holiday').hide();
	$('#exclude_btn_holiday').hide();
	$('#include_btn_weekend').hide();
	$('#exclude_btn_weekend').hide();
	
	
	///2018-03-01 使假日已选和节日已选列表根据屏幕分辨率自适应 宽度相同
	var wid=($(window).width()-350)/2
	$('#maintain').layout('panel', 'east').panel("resize", { width: wid,right:0,left:$(window).width()-wid-3});  //-3是因为有一点边框距离
	$('#maintain').layout('panel', 'center').panel("resize", { width: wid });
	
	ClearFunLib();
};
$(init);