$(function () {
	var table=GetURLParams("AutCode") //Ext.BDP.FunLib.getParam('AutCode')    //获取传过来的菜单代码
	var sheetid=1;
	if ((document.documentElement.clientHeight-240)/35>=20)
	{
		var GridpageSize=20,GridpageSize2=20,GridpageSize3=20;
	}
	else
	{
		var GridpageSize=10,GridpageSize2=10,GridpageSize3=10;
	}
    
    var GridpageArray=[10,15,20,25,50,100,200,500,1000];
    var EILType="BDPData";
    var rowcount //总行数
	var colcount //总列数
    var allDataArray=[]
    //根据校验和导入的结果 更新预校验结果列表或者导入结果列表
    
    
    //返回一个数组，其元素是在对象上找到的可枚举属性值。属性的顺序与通过手动循环对象的属性值所给出的顺序相同	  如果属性对应的属性值为龙，数组里没有这条记录。
    function getObjectValue(obj)
    {
    	try
		{
			//非IE浏览器
			var val =  Object.values(obj)//第二行的所有列   模板中文描述  
		}
		catch(e)
		{
			////IE8及以下版本不支持Object.keys、IE全版本都不支持Object.values
			var val=[],key;
		    for (key in obj) {
		        if (Object.prototype.hasOwnProperty.call(obj,key)) {
		            val.push(obj[key]);
		        }
		    }
		}
		return val;
    	
    }
    ///双击日志行，查看日志数据明细
    function Viewlogdetail()
    {
    		var rows = $("#loggrid").datagrid("getSelected"); 
            if (!(rows))
            {    
              $.messager.alert('错误提示','请先选择一条数据!','error');
                return;
            }
            else
           	{
           		var url= "dhc.bdp.mkb.bdpdatachangelogwin.csp?actiontype=datadetail&id="+rows.ID;
				if ('undefined'!==typeof websys_getMWToken)
		        {
					url += "&MWToken="+websys_getMWToken() //增加token
				}
                var logdetailwin = $HUI.dialog("#logdetailwin",{
                    resizable:true,
                    title:'日志数据详情',
                    modal:true ,
                    height:(document.documentElement.clientHeight-80),
					width:(document.documentElement.clientWidth-70),
                    content :'<iframe src=" '+url+' " width="100%" height="100%"></iframe>' 
                 });  
                $("#logdetailwin").show();
              }
     }
    
	displayLog=function ()
	{
		//显示日志
	    //日志列
	    var logcolumns =[[
	        {field:'ID',title:'ID',width:50,sortable:true,hidden:true},
	        {field:'ClassNameDesc',title:'功能描述',width:100,sortable:true},
	        {field:'TableName',title:'表名称',width:100,sortable:true},
	        {field:'ClassName',title:'类名称',width:100,sortable:true},
	        {field:'ObjectReference',title:'对象ID',width:80,sortable:true},
	        {field:'ObjectDesc',title:'对象描述',width:150,sortable:true},
	        {field:'UpdateUserName',title:'操作人',width:100,sortable:true},
	        {field:'OperateType',title:'操作类型',width:100,sortable:true},
	        {field:'IpAddress',title:'操作人IP',width:100,sortable:true},
	        {field:'UpdateUserDR',title:'操作人ID',width:100,sortable:true,hidden:true},
	        {field:'UpdateDate',title:'操作日期',width:100,sortable:true},
	        {field:'UpdateTime',title:'操作时间',width:100,sortable:true}
	    ]];
	     
	     
	    //日志列表
	    var loggrid = $HUI.datagrid("#loggrid",{
	        url:$URL,
	        columns: logcolumns,  //列信息
	        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        pageSize:20,
	        pageList:GridpageArray,
	        remoteSort:false,
	        singleSelect:true,
	        idField:'ID',
	        rownumbers:true,    //设置为 true，则显示带有行号的列。
	        fixRowNumber:true,
	        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	        onDblClickRow:function(rowIndex,rowData){
		        Viewlogdetail()  //查看数据明细
	        },
	        onLoadSuccess:function(data){
		        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
	        }   	
	    });
		$('#loggrid').datagrid('reload',  {
		 		ClassName:"web.DHCBL.BDP.BDPDataImport",
				QueryName:"GetDataLogOfImport2",
                table:table
        });
        $("#logWin").show();
		var logWin = $HUI.dialog("#logWin",{
			iconCls:'icon-paper-arrow-up',
			resizable:true,
			height:(document.documentElement.clientHeight-80),
			width:(document.documentElement.clientWidth-70),
			title:'导入基础数据日志管理',
			modal:true
		});
	}
	
    //解析校验和导入结果
    function ReturnResult(strrr,Vtype)
	{
			if ((strrr.indexOf("^")<=0))
			{
				$.messager.alert('提示',strrr,'error');
				return;			
			}
			else
			{
				var ReturnCount=strrr.split("^");		
				var TotalCount=ReturnCount[0];
				var SuccessCount=ReturnCount[1];
				var ErrorCount=ReturnCount[2];
				if (ErrorCount!=0)
				{
					// 校验、导入失败的数据 重新生成一个列表
					var AllErrorcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExErrorDataCount",EILType,table);
					var AllDataEr=[];
					var AllDataEr2=[];
			      	if (AllErrorcount>0)
					{
						for (var i=1;i<=AllErrorcount;i++){
							var dataEr=[]
							var DataDetailStr2=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetErrorFieldValue",table,i);  //行&%错误信息&%字段1值&%字段2值
							var Detail2=DataDetailStr2.split("&%");	
							var row=Detail2[0]
							var objEr={}
							var objEr=allDataArray[row-3]
							objEr["rowNum"]=row   //添加行号
							objEr["errorinfo"]=Detail2[1]   //添加错误信息
						
							for (var j=1;j<=Detail2.length;j++){
								dataEr.push(Detail2[j-1])
							}
							AllDataEr.push(dataEr);
							AllDataEr2.push(objEr);
						}
					}
					
				    if (Vtype=="V")  //预校验
					{
						$("#myTabs").tabs("select",1);
						//var alldataErobj={rows:AllDataEr2,total:AllErrorcount}
						//$('#mygrid2').datagrid('loadData', alldataErobj)  //不分页特别卡
						$('#mygrid2').datagrid('loadData',{ rows:AllDataEr2.slice(0,GridpageSize2),total:AllErrorcount})
						var pg2 = $("#mygrid2").datagrid("getPager");
		                if (pg2) {
		                    $(pg2).pagination({
		                        onSelectPage: function (pageNumber, pageSize) {
		                        	GridpageSize2=pageSize
									$('#mygrid2').datagrid('loadData',{ rows:AllDataEr2.slice((pageNumber-1)*pageSize,pageNumber*pageSize),total:AllErrorcount})
		                        }
		                    });
		                }
        				$.messager.alert('提示',"校验完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据校验通过，"+ErrorCount+"条数据校验失败。",'warning')
					}
					else  //导入
					{
						$("#myTabs").tabs("select",2)
						//var alldataErobj={rows:AllDataEr2,total:AllErrorcount}
						//$('#mygrid3').datagrid('loadData', alldataErobj) //不分页特别卡
						$('#mygrid3').datagrid('loadData',{ rows:AllDataEr2.slice(0,GridpageSize3),total:AllErrorcount})
						var pg3 = $("#mygrid3").datagrid("getPager");
		                if (pg3) {
		                    $(pg3).pagination({
		                        onSelectPage: function (pageNumber, pageSize) {
		                        	GridpageSize3=pageSize
									$('#mygrid3').datagrid('loadData',{ rows:AllDataEr2.slice((pageNumber-1)*pageSize,pageNumber*pageSize),total:AllErrorcount})
		                        }
		                    });
		                }
						$.messager.alert('提示',"导入完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据导入通过，"+ErrorCount+"条数据导入失败。",'warning')
					}
				
				}
				else
				{
					if (Vtype=="V") //预校验
					{
						$("#myTabs").tabs("select",0)
						$('#mygrid2').datagrid('loadData',{rows:[],total:0})
						$('#mygrid3').datagrid('loadData',{rows:[],total:0})
						$.messager.alert('提示',"校验完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据校验通过，"+ErrorCount+"条数据校验失败。",'info')
					}
					else //导入
					{
						$("#myTabs").tabs("select",0)
						$('#mygrid2').datagrid('loadData',{rows:[],total:0})
						$('#mygrid3').datagrid('loadData',{rows:[],total:0})
						$.messager.alert('提示',"导入完成，共计"+TotalCount+"条数据，"+SuccessCount+"条数据导入成功，"+ErrorCount+"条数据导入失败。",'info',function(){
						        displayLog() //显示日志弹窗
						});
						
						
					}
				}
				
				
				
		}
	}
	///预校验方法
    function PreCheckValidateFun()
    {
    	$.messager.progress({
			title: '提示',
			text: '正在校验,请稍候...请勿刷新或关闭窗口'
		});
    	var PreCheckValidateUrl = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataImport&pClassMethod=PreCheckValidate";
		$.ajax(
				{
					url:PreCheckValidateUrl,  
					data:{'type' : EILType},  
					type:"POST",  
					async:true,
					timeout:180000000,
					success: function(data)
					{
						if (data=='') 
						{
							$.messager.progress('close');
							$.messager.alert('提示','程序报错，校验失败','error');
						} 
						else 
						{
							$.messager.progress('close');
							ReturnResult(data,"V")	
						}			
					}  
				});
    	
    	
    }
    //预校验数据按钮
    /*$('#btnPreCheckValidate').click(function(e){
    	PreCheckValidateFun();
    });	*/
    
    //执行导入数据
	function ImportData(){
		
		var strrr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","BeforeSaveImportData",EILType);
		if (strrr!="")
		{
			$.messager.alert('提示',strrr,'error');
			return;
		}
		$('#prowin').show();
        var prowin = $HUI.dialog("#prowin", {
            iconCls: 'icon-w-import',
            resizable: false,
            //title: '',
            modal: true
        });
        $('#pro').progressbar({
            text: "正在导入中，请稍后...",
            value: 0
        });
		var row=0,ProgressText='',taskcount=rowcount;
			
		//导入数据
		var myVar = setInterval(function () {
		  	row++;
		  	if(row>taskcount) //当到达最后一行退出
		  	{
		  		$('#prowin').dialog('close')
                clearInterval(myVar)
				
				var strrr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","AfterSaveImportData",EILType);
				ReturnResult(strrr,"S")
		  	}
		  	else
		  	{
		  		var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","SaveImportDatai",EILType,row+2);
				progressText = "正在导入第" + row + "条记录,总共" + taskcount + "条记录!";
	            $('#pro').progressbar({
	                text: progressText,
	                value: 100 * row / taskcount
	            });
		  	}
		},20)		
	
	}
	
	function ShowPasswordWin()
	{
		$('#password-validate').form("clear");
    	//校验密码
    	$("#passwordWin").show();
    	var passwordWin = $HUI.dialog("#passwordWin",{
			iconCls:'icon-key',
			resizable:true,
			title:'密码校验',
			modal:true,
			buttons:[{
				text:'确定',
				handler:function(){
					var password =$.trim($("#password").val())
				    if (password=="") {
				    	$.messager.alert('提示','密码不能为空!','error');
				    	return;
				    }
				    var ImportType=$('#importtype').combobox('getValue')
				    ///新装、追加、修改时密码不同
				    var validateflag=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePassword",password,ImportType);
					if (validateflag==1)
					{	
						$('#password-validate').form("clear");
						passwordWin.close();
						ImportData()  //导入数据
				    }else{
				    	$.messager.alert('提示','密码错误请重试!','error');
					}
				}
			},{
				text:'关闭',
				handler:function(){
					passwordWin.close();
				}
			}]
		});
		$('#password').focus();
		
	}
    //一键导入按钮
   /* $('#btnImportData').click(function(e){
    	ShowPasswordWin()			
    });*/	
    
	
	
	
    ///在导入导出菜单里加一个是否允许新装配置
	if ((table=="INC_Itm")||(table=="DHC_TarItem")||(table=="ARC_ItmMast")||(table=="DHC_TarItemPrice")||(table=="SS_Group")||(table=="BDP_TableList")||(table=="SSUSRFreeText3")||(table=="TARIInsuCode"))
	{
		var importdata=[{value:'J',text:'追加数据'} ]
	}
	else
	{
		var importdata=[{value:'J',text:'追加数据'}, {value:'N',text:'新装数据(慎选)'}]
	}
	//导入类型
	$HUI.combobox("#importtype",{
		valueField:'value',
		textField:'text',
		editable:false,
		data:importdata,
		panelHeight:'auto',
		onChange:function(newValue,oldValue){
			var typeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","updateimporttype",EILType+"#"+sheetid+"#"+'importtype',newValue);
		}
	});
	$("#importtype").combobox('setValue','J')
	//读取Excel表格
    parseExcelFile=function ()
	{     
		//alert($('#'+fileboxName).filebox('files'))
		//var inputElement=$('#'+fileboxName).filebox('files')
		//alert(inputElement)
		//if(inputElement.value.indexOf(".xls")<=0 ) {alert("请选择正确的文件格式！"); return;}
		//var files = inputElement.files || [];
		var killstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","KillImportGof");   ///k ^TMPIMPORTDATA(mySysID)
		var files=$('#fileCheck').filebox('files')
		if (!files.length) {
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var file = files[0];
		var filename=file.name  //文件名
		if (filename=="")
		{
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var reader = new FileReader();
		reader.onload = function(event) {
			var arrayBuffer = reader.result;
			var options = { type: 'array', cellDates: true , cellText: false};
			var workbook = XLSX2.read(arrayBuffer, options);

			var sheetName = workbook.SheetNames[0];  //只读取第一个sheet
			var sheet = workbook.Sheets[sheetName]
	        var IsDateExisted=0
	        //对日期 和时间格式进行判断。
	        for (var key in sheet) {
	        	if (sheet[key].t && sheet[key].t == 'd')  //日期  时间 
	        	{
	        		IsDateExisted=1
	        	}
        	 }
        	 if (IsDateExisted==1)
        	 {
        	 	$.messager.alert('提示','请将表格里的“日期”或“时间”列单元格格式设置成“文本”!','error');
        	 	return;
        	 } 
        	 
			var Columndatas= XLSX2.utils.sheet_to_json(sheet) 
			var ColumnsCode=[],ColumnsDesc=[];
			// 第一行列名（模板中文描述）
			for(var col in Columndatas[0]){
			    ColumnsDesc.push(col)
			}
			var ColumnsCode=[]
		    for (var j = 0; j < ColumnsDesc.length; j++)
			{
				ColumnsCode.push(Columndatas[0][ColumnsDesc[j]])
			}
			
			//document.getElementById('pro').innerHTML = XLSX.utils.sheet_to_html(sheet)
			var datas= XLSX2.utils.sheet_to_json(sheet,{range:1})  //跳过第一行解析，从第二行开始  //, dateNF:'yyyy-mm-dd'
			//console.log(ColumnsDesc)
			//console.log(ColumnsCode)
			var sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
			rowcount = datas.length //总行数
			colcount = ColumnsCode.length//总列数
			
			
			 
			var firstColmunCode=ColumnsCode[0]
			//表格 医院列识别码特殊
			if (table=="CT_Loc")
			{
				if (firstColmunCode!='CTLOCHospitalDR')
				{
					//科室模板里的医院为CTLOCHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;
				}	
			}
			else if (table=="DHC_TarItemPrice")
			{
				if (firstColmunCode!='TPHospitalDR')
				{
					//收费项价格 TPHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_UserOtherLogonLoc")
			{
				if (firstColmunCode!='OTHLLHospitalDR')
				{
					//用户其他登录科室 OTHLLHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="DHCExaBorough")
			{
				if (firstColmunCode!='ExabHospitalDr')
				{
					//分诊区 ExabHospitalDr
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="ARC_OrdSets")
			{
				if (firstColmunCode!='FavUseHospDr')
				{
					//医嘱套 FavUseHospDr
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="CT_LocBuilding")
			{
				if (firstColmunCode!='CTLBHospitalDR')
				{
					//医院楼 CTLBHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_User") //用户 表格 医院列识别码比较特殊  放在第4列。
			{
				
			}
			else
			{
				var TableName =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetTableNameByCode",table)  //获取菜单对应的表结构登记代码
				var DataTypeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDataType",TableName)  //获取表的公私有类型
				if (DataTypeFlag!="G")
				{
					if ((firstColmunCode!='LinkHospId'))
					{	
						alert('非公有数据，第一列必须是医院！')
						return;
						
					}
				}
			}
			var propnameStr=ColumnsCode.join("&%")
			var propdescStr=ColumnsDesc.join("&%")
			///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
			var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
			if (flagstr!="") 
			{
				alert(flagstr);
				return;
			}
			
			///默认全导入  导入类型为只追加
			var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);    //propdescStr
			if (imstr!=1) 
			{
				alert(imstr);
				return;
				
			}
			var columns2=[]
	    	columns2.push({field:'rowNum',title:'对应表格行',width:130,sortable:true});
			columns2.push({field:'errorinfo',title:'报错信息',width:400,sortable:true,wordBreak:"break-all"});  //在nowrap为false时，wordBreak为列内容换行规则，任意截断：'break-all',完整单词截断：'break-word'
			var columns=[]
			columns.push({field:'rowNum',title:'对应表格行',width:130,sortable:true});
			for (var j = 0; j < colcount; j++)
			{
				//fields.push({name : 'name',mapping : 'mapping',type : 'string'});	
				var data='{"field":"'+ColumnsCode[j]+'","title":"'+ColumnsDesc[j]+'","width":"200","sortable":"true","wordBreak":"break-all"}'
				var data=eval('('+data+')'); 
				columns.push(data);
	    		columns2.push(data);
	    		//Errorcolumns.push(str);
			}
			var gridColumns=[],errorgridColumns=[]
			gridColumns.push(columns)
			errorgridColumns.push(columns2)
			allDataArray=[]	
			for (var j = 0; j < datas.length; j++)
			{
				var Data=datas[j]
				Data["rowNum"]=j+3
				allDataArray.push(Data)
			}
			 
			$('#prowin').show();
            var prowin = $HUI.dialog("#prowin", {
                iconCls: 'icon-w-import',
                resizable: false,
                title: '',
                modal: true
            });
            $('#pro').progressbar({
                text: "正在处理中，请稍后...",
                value: 0
            });
			var row=0,ProgressText='',taskcount=rowcount;
			//装载预览
			var myVar = setInterval(function () {
			  	row++;
			  	if(row>taskcount) //当到达最后一行退出
			  	{
			  		$('#prowin').dialog('close')
                    clearInterval(myVar)
                    
                    var mygrid  = $HUI.datagrid("#mygrid", {
						columns: gridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray ,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygridbar',
						nowrap:false,  //行高自动适应
				        rownumbers: false, //设置为 true，则显示带有行号的列。
				        fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					
					///数据分页显示
					$('#mygrid').datagrid('loadData',{ rows:allDataArray.slice(0,GridpageSize),total:rowcount})
					var pg = $("#mygrid").datagrid("getPager");
	                if (pg) {
	                    $(pg).pagination({
	                        onSelectPage: function (pageNumber, pageSize) {
	                        	GridpageSize=pageSize
								$('#mygrid').datagrid('loadData',{ rows:allDataArray.slice((pageNumber-1)*pageSize,pageNumber*pageSize),total:rowcount})
	                        }
	                    });
	                }
					var mygrid2 = $HUI.datagrid("#mygrid2", {
						columns: errorgridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygrid2bar',
						nowrap:false,  //行高自动适应
						rownumbers: false, //设置为 true，则显示带有行号的列。
						fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					var mygrid3 = $HUI.datagrid("#mygrid3", {
						columns: errorgridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygrid3bar',
						nowrap:false,  //行高自动适应
						rownumbers: false, //设置为 true，则显示带有行号的列。
						fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					$("#myWin").show();
					var myWin = $HUI.dialog("#myWin",{
						iconCls:'icon-paper-arrow-up',
						resizable:true,
						top:10,
						height:(document.documentElement.clientHeight-80),
						width:(document.documentElement.clientWidth-20),
						title:'装载',
						modal:true,
						buttonAlign : 'center',
						buttons:[{
							text:'预校验数据',
							iconCls:'icon-w-filter',
							handler:function(){
								PreCheckValidateFun();
							}
						},{
							text:'一键导入',
							iconCls:'icon-w-import',
							handler:function(){
								ShowPasswordWin()
							}
						},{
							text:'关闭',
							iconCls:'icon-w-close',
							handler:function(){
								myWin.close();
							}
						}]
					});
					$HUI.tabs("#myTabs",{
						onSelect:function(title){
							//$.messager.popover({type:'info',msg:'切换到【'+title+'】'}); 					
						}
					});
					$("#myTabs").tabs("select",0)
					$("#importtype").combobox('setValue','J')
			  	}
			  	else
			  	{
			  		progressText = "正在读取第" + row + "条记录,总共" + taskcount + "条记录!";
		            $('#pro').progressbar({
		                text: progressText,
		                value: 100 * row / taskcount
		            });
		            ///有一个问题是 如果字段值为龙，取出来的ColumnsValue里是没有这个字段 为空的记录
				  	//var ColumnsValue = getObjectValue(datas[row])//第3行开始的值
				  	var ColumnsValue=[]
				    for (var j = 0; j < ColumnsCode.length; j++)
					{
						ColumnsValue.push(datas[row-1][ColumnsCode[j]])
					}
				    var tempStr=ColumnsValue.join("&%")
				    var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,(row+2),tempStr,"Y");  //默认Y ，不通过勾选选择了  2017-2-11			
			  	}
			},20)
			  
		};
		reader.readAsArrayBuffer(file);
    }
    //导出错误信息到Excel
    function ExportErrorInfoToExcel() 
    {
    	var xlsName=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);;
		if (xlsName!="") 
		{
			var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExErrorDataCount",EILType,table);  //获取要导出的总条数  
			if (taskcount==0)
			{
				$.messager.alert('提示','没有错误数据','error');
				return;
			}
			if (taskcount>0)
			{
				var TotalArray=[] //定义数组，用于给table赋值
				///第一行为描述，第二行为字段名，数据从第三行开始
				var fieldinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetFieldInfo",table);  
				var fieldInfoArray=fieldinfostr.split("&%");
				//模板数组，第一行，第二行
				var titlenamearr=[],titlecodearr=[];
				for (var m = 0; m < fieldInfoArray.length; m++) {
					var fieldInfo=fieldInfoArray[m]
					var fieldArr=fieldInfo.split("*&");
					
					titlenamearr.push(fieldArr[0]);   ///第一行 字段描述
		    		titlecodearr.push(fieldArr[1]);   ///第二行 字段名
				}
				titlenamearr.push("对应表格行");
				titlecodearr.push("rowNum");
				titlenamearr.push("报错信息");
				titlecodearr.push("errorinfo");
				//xlsheet.cells(row_from-2,TitleInfoArr.length+1).Font.Bold = true; //设置为粗体
				//xlsheet.cells(row_from-2,TitleInfoArr.length+2).Font.Bold = true; //设置为粗体\
				TotalArray.push(titlenamearr);
				TotalArray.push(titlecodearr);
				
				$('#prowin').show();
	            var prowin = $HUI.dialog("#prowin", {
	                iconCls: 'icon-w-import',
	                resizable: false,
	                title: '',
	                modal: true
	            });
	            $('#pro').progressbar({
	                text: "正在导出中，请稍后...",
	                value: 0
	            });
				var row=0,ProgressText='',taskcount=taskcount;
				var myVar = setInterval(function () {
				  	row++;
					if(row>taskcount) //当到达最后一行退出
				  	{
				  		//var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
				  		
				  		$('#prowin').dialog('close')
                    	clearInterval(myVar)
						
						var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
				        var mycolcount=0;
				        for (var key in sheet) {
				        	if ((key=='A3')||(key=='!ref')){break;}
				        	//非必填项模板颜色黑色
				        	sheet[key]["s"] = {
					            font: {
					                name: '宋体',
					                sz: 14,
					                bold: true,
					                underline: false,
					                color: {
					                    rgb: "000000"  //黑色
					                }
					            },
					            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
					                horizontal: "center",
					                vertical: "center",
					                wrap_text: true
					            }
					        };
						    var fieldi=mycolcount%(fieldInfoArray.length+2)  //取余
						    mycolcount=mycolcount+1;
						    var fieldInfo=fieldInfoArray[fieldi]
					        if((fieldInfo==undefined)||(fieldInfo=="undefined")){  continue;}
					        var fieldArr=fieldInfo.split("*&");
							if (fieldArr[2]==1) //必填项
							{
								//必填项模板颜色红色
						        sheet[key]["s"] = {
						            font: {
						                name: '宋体',
						                sz: 14,
						                bold: true,
						                underline: false,
						                color: {
						                    rgb: "FF0000"  //红色
						                }
						            },
						            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
						                horizontal: "center",
						                vertical: "center",
						                wrap_text: true
						            }
						        };
							}
				        	
						};
						var cosWidth=[];
						for (var i=0;i<(fieldInfoArray.length+2);i++){
							cosWidth.push({wpx:150})
						}
						sheet["!cols"]=cosWidth; //控制单元格的宽度
				        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
						
				  	}
				  	else
				  	{
						progressText = "正在导出第" + row + "条记录,总共" + taskcount + "条记录!";
			            $('#pro').progressbar({
			                text: progressText,
			                value: 100 * row / taskcount
			            });
						//将每条数据加到数组里
						var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelErrorFieldValue",table,row);
						var DetailArray=DataDetailStr.split("&%");
					    TotalArray.push(DetailArray)
					  }
				 },20)
			}
			
		}  
		else
		{
			$.messager.alert('提示','没有获取到表格配置，请重新确认','error');
			return;
		}
    }
    //导出错误信息到Excel按钮-预校验结果
    $('#ExportErrorInfo').click(function(e){
    	if($("#mygrid2").datagrid("getData").total == 0 )
    	{
    		//没数据
		    $.messager.alert('提示','没有获取到数据，请重新确认','error');
		}
		else
		{
		    //有数据
			ExportErrorInfoToExcel();
		};
    	
    });
    
    //导出错误信息到Excel按钮-导入结果
    $('#ExportErrorInfo2').click(function(e){
    	if($("#mygrid3").datagrid("getData").total == 0 )
    	{
    		//没数据
		    $.messager.alert('提示','没有获取到数据，请重新确认','error');
		}
		else
		{
		    //有数据
			ExportErrorInfoToExcel();
		};
    });
     //导出所有数据及其错误信息到Excel
    function ExportAllInfoToExcel()
    {
    	var xlsName=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);;
		if (xlsName!="") 
		{
			var taskcount=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetAllExErrorDataCount",EILType,table);  //获取要导出的总条数  
			if (taskcount==0)
			{
				$.messager.alert('提示','没有错误数据','error');
				return;
			}
			if (taskcount>0)
			{
				var TotalArray=[] //定义数组，用于给table赋值
				///第一行为描述，第二行为字段名，数据从第三行开始
				var fieldinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetFieldInfo",table);  
				var fieldInfoArray=fieldinfostr.split("&%");
				//模板数组，第一行，第二行
				var titlenamearr=[],titlecodearr=[];
				for (var m = 0; m < fieldInfoArray.length; m++) {
					var fieldInfo=fieldInfoArray[m]
					var fieldArr=fieldInfo.split("*&");
					
					titlenamearr.push(fieldArr[0]);   ///第一行 字段描述
		    		titlecodearr.push(fieldArr[1]);   ///第二行 字段名
				}
				titlenamearr.push("对应表格行");
				titlecodearr.push("");
				
				titlenamearr.push("报错信息");
				titlecodearr.push("");
				//xlsheet.cells(row_from-2,TitleInfoArr.length+1).Font.Bold = true; //设置为粗体
				//xlsheet.cells(row_from-2,TitleInfoArr.length+2).Font.Bold = true; //设置为粗体\
				TotalArray.push(titlenamearr);
				TotalArray.push(titlecodearr);
				
				$('#prowin').show();
	            var prowin = $HUI.dialog("#prowin", {
	                iconCls: 'icon-w-import',
	                resizable: false,
	                title: '',
	                modal: true
	            });
	            $('#pro').progressbar({
	                text: "正在导出中，请稍后...",
	                value: 0
	            });
				var row=0,ProgressText='',taskcount=taskcount;
				var myVar = setInterval(function () {
				  	row++;
					if(row>taskcount) //当到达最后一行退出
				  	{
				  		//var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
				  		
				  		$('#prowin').dialog('close')
                    	clearInterval(myVar)
                    	
						var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
				        var mycolcount=0;
				        for (var key in sheet) {
				        	if ((key=='A3')||(key=='!ref')){break;}
				        	//非必填项模板颜色黑色
							sheet[key]["s"] = {
					            font: {
					                name: '宋体',
					                sz: 14,
					                bold: true,
					                underline: false,
					                color: {
					                    rgb: "000000"  //黑色
					                }
					            },
					            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
					                horizontal: "center",
					                vertical: "center",
					                wrap_text: true
					            }
					        };
						    var fieldi=mycolcount%(fieldInfoArray.length+2)  //取余
						    mycolcount=mycolcount+1;
					        var fieldInfo=fieldInfoArray[fieldi]
					        if((fieldInfo==undefined)||(fieldInfo=="undefined")){  continue;}
							var fieldArr=fieldInfo.split("*&");
							if (fieldArr[2]==1) //必填项
							{
								//必填项模板颜色红色
						        sheet[key]["s"] = {
						            font: {
						                name: '宋体',
						                sz: 14,
						                bold: true,
						                underline: false,
						                color: {
						                    rgb: "FF0000"  //红色
						                }
						            },
						            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
						                horizontal: "center",
						                vertical: "center",
						                wrap_text: true
						            }
						        };
							}
						};
						var cosWidth=[];
						for (var i=0;i<(fieldInfoArray.length+2);i++){
							cosWidth.push({wpx:150})
						}
						sheet["!cols"]=cosWidth; //控制单元格的宽度
				        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
						
						
				  	}
				  	else
				  	{
						progressText = "正在导出第" + row + "条记录,总共" + taskcount + "条记录!";
			            $('#pro').progressbar({
			                text: progressText,
			                value: 100 * row / taskcount
			            });
						//将每条数据加到数组里 
						var DataDetailStr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelAllErrorFieldValue",table,row+2); //要加2！
						var DetailArray=DataDetailStr.split("&%");
					    TotalArray.push(DetailArray)
					  }
				 },20)
			}
			
		}  
		else
		{
			$.messager.alert('提示','没有获取到表格配置，请重新确认','error');
			return;
		}
    	
    }
    //导出所有数据及其错误信息到Excel按钮-预校验结果
    $('#ExportAllInfo').click(function(e){
    	if($("#mygrid2").datagrid("getData").total == 0 )
    	{
    		//没数据
		    $.messager.alert('提示','没有获取到数据，请重新确认','error');
		}
		else
		{
		    //有数据
			ExportAllInfoToExcel();
		};
    });	
     //导出所有数据及其错误信息到Excel按钮-导入结果
    $('#ExportAllInfo2').click(function(e){
    	if($("#mygrid3").datagrid("getData").total == 0 )
		{
			//没数据
		    $.messager.alert('提示','没有获取到数据，请重新确认','error');
		}
		else
		{
		    //有数据
			ExportAllInfoToExcel();
		};
    	
    });	
    //下载导入模板
    function ExcelExportTemplet()
    {
    	////  工作簿名&%字段name1^字段描述1^是否必填0&#字段name2^字段描述2^是否必填1 ///按照顺序字段取字段信息，有维护顺序的排在前面，空的排在后面
		var excelinfostr=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetTempletFieldDesc",table);
		if (excelinfostr=="") {alert("请先设置导入导出配置表"); return;}
		var excelinfo=excelinfostr.split("&%");
		var xlsName=excelinfo[0];
		if (xlsName=="")
		{
			$.messager.alert('提示','没有获取到表格配置，请重新确认','error');
			return;
		}
		var TotalArray=[] //定义数组，用于给table赋值
		var fieldinfostr=excelinfo[1];
		var fieldInfoArray=fieldinfostr.split("&#");
		//模板数组，第一行，第二行
		var titlenamearr=[],titlecodearr=[];
		for (var i=0;i<(fieldInfoArray.length);i++){
			
			var fieldInfo=fieldInfoArray[i]
			var fieldArr=fieldInfo.split("^");
			titlenamearr.push(fieldArr[0]);   ///第一行 字段描述
		    titlecodearr.push(fieldArr[1]);   ///第二行 字段名
		}
		
		TotalArray.push(titlenamearr);
		TotalArray.push(titlecodearr);
		//var ExcelInstruction=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetExcelInstruction",table);
		var sheet = XLSX2.utils.aoa_to_sheet(TotalArray);
        var mycolcount=0;
        for (var key in sheet) {
        	if ((key=='A3')||(key=='!ref')){break;}
        	//非必填项模板颜色黑色
			sheet[key]["s"] = {
	            font: {
	                name: '宋体',
	                sz: 14,
	                bold: true,
	                underline: false,
	                color: {
	                    rgb: "000000"  //黑色
	                }
	            },
	            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
	                horizontal: "center",
	                vertical: "center",
	                wrap_text: true
	            }
	        };
		    var fieldi=mycolcount%(fieldInfoArray.length)  //取余
		    mycolcount=mycolcount+1;
	        var fieldInfo=fieldInfoArray[fieldi]
			var fieldArr=fieldInfo.split("^");
			if (fieldArr[2]==1) //必填项
			{
				//必填项模板颜色红色
		        sheet[key]["s"] = {
		            font: {
		                name: '宋体',
		                sz: 14,
		                bold: true,
		                underline: false,
		                color: {
		                    rgb: "FF0000"  //红色
		                }
		            },
		            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
		                horizontal: "center",
		                vertical: "center",
		                wrap_text: true
		            }
		        };
			}
		};
		var cosWidth=[];
		for (var i=0;i<(fieldInfoArray.length);i++){
			cosWidth.push({wpx:150})
		}
		sheet["!cols"]=cosWidth; //控制单元格的宽度
        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+'xlsx');
    }
     //下载导入模板
    $('#ExcelExportTemplet').click(function(e){
    	ExcelExportTemplet();
    });	
    
    //重新读取Excel表格
    reloadExcelFile=function ()
	{     
		//alert($('#'+fileboxName).filebox('files'))
		//var inputElement=$('#'+fileboxName).filebox('files')
		//alert(inputElement)
		//if(inputElement.value.indexOf(".xls")<=0 ) {alert("请选择正确的文件格式！"); return;}
		//var files = inputElement.files || [];
		var killstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","KillImportGof");   ///k ^TMPIMPORTDATA(mySysID)
		var files=$('#fileCheck').filebox('files')
		if (!files.length) {
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var file = files[0];
		var filename=file.name  //文件名
		if (filename=="")
		{
			$.messager.alert('提示','请先选择文件!','error');
			return;
		}
		var reader = new FileReader();
		reader.onload = function(event) {
			var arrayBuffer = reader.result;
			var options = { type: 'array', cellDates: true , cellText: false};
			var workbook = XLSX2.read(arrayBuffer, options);

			var sheetName = workbook.SheetNames[0];  //只读取第一个sheet
			var sheet = workbook.Sheets[sheetName]
	        var IsDateExisted=0
	        //对日期 和时间格式进行判断。
	        for (var key in sheet) {
	        	if (sheet[key].t && sheet[key].t == 'd')  //日期  时间 
	        	{
	        		IsDateExisted=1
	        	}
        	 }
        	 if (IsDateExisted==1)
        	 {
        	 	$.messager.alert('提示','请将表格里的“日期”或“时间”列单元格格式设置成“文本”!','error');
        	 	return;
        	 } 
        	 
			var Columndatas= XLSX2.utils.sheet_to_json(sheet) 
			var ColumnsCode=[],ColumnsDesc=[];
			// 第一行列名（模板中文描述）
			for(var col in Columndatas[0]){
			    ColumnsDesc.push(col)
			}
			var ColumnsCode=[]
		    for (var j = 0; j < ColumnsDesc.length; j++)
			{
				ColumnsCode.push(Columndatas[0][ColumnsDesc[j]])
			}
			
			//document.getElementById('pro').innerHTML = XLSX.utils.sheet_to_html(sheet)
			var datas= XLSX2.utils.sheet_to_json(sheet,{range:1})  //跳过第一行解析，从第二行开始  //, dateNF:'yyyy-mm-dd'
			//console.log(ColumnsDesc)
			//console.log(ColumnsCode)
			var sheetname=tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","GetMenuDesc",table);  ////获取菜单导入导出代码对应的描述
			rowcount = datas.length //总行数
			colcount = ColumnsCode.length//总列数
			
			
			 
			var firstColmunCode=ColumnsCode[0]
			//表格 医院列识别码特殊
			if (table=="CT_Loc")
			{
				if (firstColmunCode!='CTLOCHospitalDR')
				{
					//科室模板里的医院为CTLOCHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;
				}	
			}
			else if (table=="DHC_TarItemPrice")
			{
				if (firstColmunCode!='TPHospitalDR')
				{
					//收费项价格 TPHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_UserOtherLogonLoc")
			{
				if (firstColmunCode!='OTHLLHospitalDR')
				{
					//用户其他登录科室 OTHLLHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="DHCExaBorough")
			{
				if (firstColmunCode!='ExabHospitalDr')
				{
					//分诊区 ExabHospitalDr
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="ARC_OrdSets")
			{
				if (firstColmunCode!='FavUseHospDr')
				{
					//医嘱套 FavUseHospDr
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="CT_LocBuilding")
			{
				if (firstColmunCode!='CTLBHospitalDR')
				{
					//医院楼 CTLBHospitalDR
					alert('非公有数据，医院列必须在第一列！')
					return;	
				}
			}
			else if (table=="SS_User") //用户 表格 医院列识别码比较特殊  放在第4列。
			{
				
			}
			else
			{
				var TableName =tkMakeServerCall("web.DHCBL.BDP.BDPEIMenu","GetTableNameByCode",table)  //获取菜单对应的表结构登记代码
				var DataTypeFlag =tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDataType",TableName)  //获取表的公私有类型
				if (DataTypeFlag!="G")
				{
					if ((firstColmunCode!='LinkHospId'))
					{	
						alert('非公有数据，第一列必须是医院！')
						return;
						
					}
				}
			}
			var propnameStr=ColumnsCode.join("&%")
			var propdescStr=ColumnsDesc.join("&%")
			///2017-03-23 校验字段列有没有空，有没有重复的，有没有没配置的  有没有必填项缺少的
			var flagstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ValidatePropertyName",table,propnameStr)
			if (flagstr!="") 
			{
				alert(flagstr);
				return;
			}
			
			///默认全导入  导入类型为只追加
			var imstr =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportTabBaseInfo",EILType,sheetid,sheetname,table,propdescStr,propnameStr);    //propdescStr
			if (imstr!=1) 
			{
				alert(imstr);
				return;
				
			}
			/*var columns2=[]
	    	columns2.push({field:'rowNum',title:'对应表格行',width:130,sortable:true});
			columns2.push({field:'errorinfo',title:'报错信息',width:400,sortable:true,wordBreak:"break-all"});  //在nowrap为false时，wordBreak为列内容换行规则，任意截断：'break-all',完整单词截断：'break-word'
			var columns=[]
			columns.push({field:'rowNum',title:'对应表格行',width:130,sortable:true});
			for (var j = 0; j < colcount; j++)
			{
				//fields.push({name : 'name',mapping : 'mapping',type : 'string'});	
				var data='{"field":"'+ColumnsCode[j]+'","title":"'+ColumnsDesc[j]+'","width":"200","sortable":"true","wordBreak":"break-all"}'
				var data=eval('('+data+')'); 
				columns.push(data);
	    		columns2.push(data);
	    		//Errorcolumns.push(str);
			}
			var gridColumns=[],errorgridColumns=[]
			gridColumns.push(columns)
			errorgridColumns.push(columns2)*/
			allDataArray=[]	
			for (var j = 0; j < datas.length; j++)
			{
				var Data=datas[j]
				Data["rowNum"]=j+3
				allDataArray.push(Data)
			}
			 
			$('#prowin').show();
            var prowin = $HUI.dialog("#prowin", {
                iconCls: 'icon-w-import',
                resizable: false,
                title: '',
                modal: true
            });
            $('#pro').progressbar({
                text: "正在处理中，请稍后...",
                value: 0
            });
			var row=0,ProgressText='',taskcount=rowcount;
			//装载预览
			var myVar = setInterval(function () {
			  	row++;
			  	if(row>taskcount) //当到达最后一行退出
			  	{
			  		$('#prowin').dialog('close')
                    clearInterval(myVar)
                    
                    /*var mygrid  = $HUI.datagrid("#mygrid", {
						columns: gridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray ,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygridbar',
						nowrap:false,  //行高自动适应
				        rownumbers: false, //设置为 true，则显示带有行号的列。
				        fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					*/
					///数据分页显示
					$('#mygrid').datagrid('loadData',{ rows:allDataArray.slice(0,GridpageSize),total:rowcount})
					var pg = $("#mygrid").datagrid("getPager");
	                if (pg) {
	                    $(pg).pagination({
	                        onSelectPage: function (pageNumber, pageSize) {
	                        	GridpageSize=pageSize
								$('#mygrid').datagrid('loadData',{ rows:allDataArray.slice((pageNumber-1)*pageSize,pageNumber*pageSize),total:rowcount})
	                        }
	                    });
	                }
					/*var mygrid2 = $HUI.datagrid("#mygrid2", {
						columns: errorgridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygrid2bar',
						nowrap:false,  //行高自动适应
						rownumbers: false, //设置为 true，则显示带有行号的列。
						fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					var mygrid3 = $HUI.datagrid("#mygrid3", {
						columns: errorgridColumns,
						data:[],
						pagination: true, //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
						pageSize: GridpageSize,
						pageList:GridpageArray,
						singleSelect: true,
						idField: 'rowNum',
						toolbar:'#mygrid3bar',
						nowrap:false,  //行高自动适应
						rownumbers: false, //设置为 true，则显示带有行号的列。
						fixRowNumber:true,  //让行号列自适应宽度
						fitColumns: false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
						onDblClickRow: function(rowIndex, rowData) {
							
						}
					});
					$("#myWin").show();
					var myWin = $HUI.dialog("#myWin",{
						iconCls:'icon-paper-arrow-up',
						resizable:true,
						top:10,
						height:(document.documentElement.clientHeight-80),
						width:(document.documentElement.clientWidth-20),
						title:'装载',
						modal:true,
						buttonAlign : 'center',
						buttons:[{
							text:'预校验数据',
							iconCls:'icon-w-filter',
							handler:function(){
								PreCheckValidateFun();
							}
						},{
							text:'一键导入',
							iconCls:'icon-w-import',
							handler:function(){
								ShowPasswordWin()
							}
						},{
							text:'关闭',
							iconCls:'icon-w-close',
							handler:function(){
								myWin.close();
							}
						}]
					});
					$HUI.tabs("#myTabs",{
						onSelect:function(title){
							//$.messager.popover({type:'info',msg:'切换到【'+title+'】'}); 					
						}
					});
					$("#myTabs").tabs("select",0)
					*/
					
					$('#mygrid2').datagrid('loadData',{ rows:[].slice(0,GridpageSize2),total:0})
					$('#mygrid3').datagrid('loadData',{ rows:[].slice(0,GridpageSize3),total:0})
					$("#importtype").combobox('setValue','J')
			  	}
			  	else
			  	{
			  		progressText = "正在读取第" + row + "条记录,总共" + taskcount + "条记录!";
		            $('#pro').progressbar({
		                text: progressText,
		                value: 100 * row / taskcount
		            });
		            ///有一个问题是 如果字段值为龙，取出来的ColumnsValue里是没有这个字段 为空的记录
				  	//var ColumnsValue = getObjectValue(datas[row])//第3行开始的值
				  	var ColumnsValue=[]
				    for (var j = 0; j < ColumnsCode.length; j++)
					{
						ColumnsValue.push(datas[row-1][ColumnsCode[j]])
					}
				    var tempStr=ColumnsValue.join("&%")
				    var Flag =tkMakeServerCall("web.DHCBL.BDP.BDPDataImport","ImportIntoGlobal",EILType,table,sheetid,(row+2),tempStr,"Y");  //默认Y ，不通过勾选选择了  2017-2-11			
			  	}
			},20)
			  
		};
		reader.readAsArrayBuffer(file);
    }
     //重新装载数据
    $('#ReloadExcel').click(function(e){
    	reloadExcelFile();
    });	
    //导出的表格不需要样式
    //引入js:
    //<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/shim.min.js"> </script>
	//<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.full.min.js"> </script>
	//<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/Blob.js"> </script>
	//<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/FileSaver.js"> </script>
    //ExportExcel(TotalArray,'区域','xlsx')
    function ExportExcel(dataArray,xlsName,xlsType)
    {
    	var fn,dl
		var sheet = XLSX.utils.aoa_to_sheet(dataArray);
		var html_string = XLSX.utils.sheet_to_html(sheet, { id: "data-table", editable: true });
		var elt = document.getElementById('data-table');  
		var wb = XLSX.utils.table_to_book(elt, {sheet:"Sheet JS"});  //将表格导出成xlsx
		return dl ?
			XLSX.write(wb, {bookType:xlsType, bookSST:true, type: 'base64'}) :
			XLSX.writeFile(wb, fn || (xlsName+'.' + (xlsType || 'xlsx')));
			
    }
    
    //导出的表格需要样式
    //引入js:
    //<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx.extendscript.js"> </script>
	//<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/xlsx-style/xlsx.full.min.js"> </script>
	//<script type="text/javascript" src="../scripts/bdp/Framework/scripts/xlsx/export.js"> </script>
    //ExportExcel2(TotalArray,'区域','xlsx')
    function ExportExcel2(dataArray,xlsName,xlsType)
    {
    	var sheet = XLSX2.utils.aoa_to_sheet(dataArray);
		sheet["A1"]["s"] = {
            font: {
                name: '宋体',
                sz:14,
                bold: true,
                underline: false,
                color: {
                    rgb: "FF0000"  //红色
                }
            },
            alignment: {  //设置标题水平竖直方向居中，并自动换行展示
                horizontal: "center",
                vertical: "center",
                wrap_text: true
            }
        };	
        openDownloadDialog(sheet2blob(sheet), xlsName+'.'+xlsType);	
    }
})