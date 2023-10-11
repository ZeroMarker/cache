//三管感染防控督查表[Gui]
var objScreen = new Object();
function InitIExARepWin() {
    var obj = objScreen;
	
	obj.IExAID = IExAID;		//报告ID
	obj.IsAdmin=IsAdmin;		//管理员权限
	var IPStaDay = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "IExAStartDay"
	}, false);
	obj.PICCStaDay=IPStaDay.split("-")[0];		//中央导管开始评估(默认3)
	obj.VAPStaDay=IPStaDay.split("-")[1];		//呼吸机开始评估(默认3)
	obj.UCStaDay=IPStaDay.split("-")[2];		//导尿管开始评估(默认3)
	
	obj.IsEdit="1";			//编辑权限
	var IsEditIExARep=$m({
    	ClassName: "DHCHAI.BT.Config",
        MethodName: "GetValByCode",
        aCode: "IsEditIExARep"
    }, false)
	 if((obj.IsAdmin=="1")&&(IsEditIExARep=="0"))obj.IsEdit="0";
	
	
    //加载'三管感染防控督查表'
    obj.gridIntuRep = $HUI.datagrid("#gridIntuRep", {
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        singleSelect: true,
        loadMsg:'数据加载中...',
		loading:true,
        nowrap: false,
        columns: [[
			{ field: 'DicTypeDesc', title: '项目', width: 50, align: 'center' },
            { field: 'DicDesc', title: '督查内容/插管天数', width: 280, align: 'left' },
            {
                field: 'Item1', title: '日期1', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,1);
                },
            },
            {
                field: 'Item2', title: '日期2', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,2);
                },
            },
            {
                field: 'Item3', title: '日期3', width: 58, align: 'center',
                formatter: function (value, row, index) {
                     return obj.GetCellRet(row.DicTypeDesc,value,index,3);
                },
            },
            {
                field: 'Item4', title: '日期4', width: 58, align: 'center',
                formatter: function (value, row, index) {
                     return obj.GetCellRet(row.DicTypeDesc,value,index,4);
                },
            },
            {
                field: 'Item5', title: '日期5', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,5);
                },
            },
            {
                field: 'Item6', title: '日期6', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,6);
                },
            },
            {
                field: 'Item7', title: '日期7', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,7);
                },
            },
            {
                field: 'Item8', title: '日期8', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,8);
                },
            },
            {
                field: 'Item9', title: '日期9', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,9);
                },
            },
            {
                field: 'Item10', title: '日期10', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,10);
                },
            },
            {
                field: 'Item11', title: '日期11', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,11);
                },
            },
            {
                field: 'Item12', title: '日期12', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,12);
                },
            },
            {
                field: 'Item13', title: '日期13', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,13);
                },
            },
            {
                field: 'Item14', title: '日期14', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,14);
                },
            },
            {
                field: 'Item15', title: '日期15', width: 58, align: 'center',
                formatter: function (value, row, index) {
                    return obj.GetCellRet(row.DicTypeDesc,value,index,15);
                },
            },
        ]],
        onClickCell: function (Index, field, value) {
	        var ID=field.split("m")[1];
	        if(obj.IsEdit=="0")return;				//不可编辑
	        
	        //置管天数
	        var StaDay=1;
       		if(obj.TubeType=="PICC")var StaDay=obj.PICCStaDay;
       		if(obj.TubeType=="VAP")var StaDay=obj.VAPStaDay;
       		if(obj.TubeType=="UC")var StaDay=obj.UCStaDay;
       		
			var TubeDay=parseInt([15*(obj.Page-1)+(ID-1)])+parseInt(StaDay);	
			
	        var IsAssert = $("#ckIP_"+ID).val();
	        if(Index=="0"){		
	        	if(TubeDay>parseInt(obj.IADays))return;	
			    if(IsAssert=="1"){
				    //复选框'取消选中'
					$("#ckIP_"+ID).val("0");
					$("#ckIP_"+ID).removeAttr("checked")
					//取消'选中列'颜色
					$('.datagrid-btable td[field=' + field + ']').css("background-color","");
					//取消'评估人'+'评估日期'
					var IsAssDay = $m({		
                		ClassName: "DHCHAI.IRS.ICUIExASrv",
                		MethodName: "GetIsAssertByDay",
                		aIExAID: obj.IExAID,
                		aDay: TubeDay
            		}, false)
            		if (IsAssDay=="0") {
               		 	$("#txtIPUser_" +ID).html("");
                		$("#txtIPDate_" +ID ).html("");
            		};
				}
				else{
					 //复选框'选中'
					$("#ckIP_"+ID).val("1");
					$("#ckIP_"+ID).prop("checked",'true')
					//'选中列'颜色
           			$('.datagrid-btable td[field=' + field + ']').css("background-color", "#e5f3fc");
					//设置'评估人'+'评估日期'
					var AfterDate = $m({		
                		ClassName: "DHCHAI.IRS.ICUIExASrv",
                		MethodName: "GetAfterDate",
                		aNowDate:$('#txtIntuDate').combobox('getValue'),
                		aSubDay: TubeDay
            		}, false)
            		$("#txtIPUser_" +ID).html($.LOGON.USERDESC);
                	$("#txtIPDate_" +ID ).html(AfterDate.substring(5));
				}
			}
		    else{						//'具体内容'
		    	if(IsAssert!="1")return;
			    //更新内容'✔'->'✖'
			    var CellText=$("#txtIPRes_"+Index+"_"+ID).text();
			   	if (CellText == "") $("#txtIPRes_"+Index+"_"+ID).text("✔");
				if (CellText == "✔") $("#txtIPRes_"+Index+"_"+ID).text("✖");
				if (CellText == "✖") $("#txtIPRes_"+Index+"_"+ID).text("");
				var ItemVal = "";			//项目值
				var CellText=$("#txtIPRes_"+Index+"_"+ID).text();
				switch (CellText) {
					case "✔": ItemVal = 1; break;
                    case "✖": ItemVal = -1; break;
					case "": ItemVal = 0; break;
					default: break;
				}
				
				//拔管(撤机)
				var DicID = $('#gridIntuRep').datagrid('getRows')[Index].DicID;
				var DicCode = $('#gridIntuRep').datagrid('getRows')[Index].DicCode;
				if((ItemVal=="1")&&(DicCode.indexOf("-Draw")>=0)){
					$.messager.confirm("提示", '是否拔管/撤机?', function (r) {
						if (r) {
							//更新拔管日期
							var AfterDate = $m({		
                				ClassName: "DHCHAI.IRS.ICUIExASrv",
                				MethodName: "GetAfterDate",
                				aNowDate:$('#txtIntuDate').combobox('getValue'),
                				aSubDay: TubeDay
            				}, false)
            				obj.ExtuDate = $('#txtExtuDate').datebox('setValue',AfterDate);  
            				//更新'督察表'
							obj.SaveIExA(); 
                         
						}
						else{
							$(CellID).text("");
							ItemVal = 0;
						}
					});
				}
				//保存填写记录
				var InputStr = obj.IExAID + "^" + "" + "^" + DicID + "^" + TubeDay + "^" + ItemVal + "^" + $.LOGON.USERID;
				obj.SaveIExAExt(InputStr);
			}   
        },
        onLoadSuccess: function (data) {
	        if (data.total > 0) {
	        	dispalyEasyUILoad(); 			//隐藏效果
              	
              	var StaDay=1;
       			if(obj.TubeType=="PICC")var StaDay=obj.PICCStaDay;
       			if(obj.TubeType=="VAP")var StaDay=obj.VAPStaDay;
       			if(obj.TubeType=="UC")var StaDay=obj.UCStaDay;
       			
              	for (var i = 1; i <= 15; i++) {
	              	var ID="Item"+i;
	              	//置管天数
					var TubeDay=parseInt([15*(obj.Page-1)+(i-1)])+parseInt(StaDay);	
					
					//刷新'感染标记'
					if(obj.InfList.indexOf("|"+TubeDay+"-")>=0){
						$('.datagrid-htable td[field="' + ID + '"]').css("background-color", "red");
					}
					else{
						$('.datagrid-htable td[field="' + ID + '"]').css("background-color", "");
					}
              		//刷新'不可选中'
					if(TubeDay>parseInt(obj.IADays)){
						$("#ckIP_"+i).prop("disabled", true);
	            		$("#ckIP_"+i).val(-1);
						$('.datagrid-btable td[field=' + ID + ']').css("background-color", "#f7f7f7");
					}
              	}
              	
                //合并单元格实现表格样式
                $(this).datagrid("autoMergeCells", ['DicTypeDesc']);    	//合并行
               	$(this).datagrid('mergeCells', {       		//合并列
					index: 0,
					field: ['DicTypeDesc'],
					colspan: 2
				});
				$(this).datagrid('mergeCells', {       		//合并列
					index: 1,
					field: ['DicTypeDesc'],
					colspan: 2
				});
        		if(obj.PrintType==""){
					$(this).datagrid('mergeCells', {       //合并列
						index: 2,
			   			field: ['DicTypeDesc'],
						colspan: 2
					});
	    		}
            }
        }
    });
    
    //加载'患者'对应类别的评估表
	obj.gridIExAReport = $('#gridIExAReport').datagrid({
		fit: true,
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true, 			//如果为true, 则显示一个行号列
		singleSelect: true,
		fitColumns: true,
		loadMsg: '数据加载中...',
        columns: [[
			{ field: 'DicDesc', title: '插管类型', width: 200 },
			{ field: 'IntuDate', title: '置管日期', width: 100 },
			{ field: 'ExtuDate', title: '拔管日期', width: 120 },
			{
				field: 'IsActive', title: '操作', width: 60, align: 'center',
				formatter: function (value, row, index) {
					if (value == 1) {
						return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.UpdateStatus(\"" + row.IExAID + "\",\"" + 0 + "\");'>删除</a>";
					}
					else {
						return "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.UpdateStatus(\"" + row.IExAID + "\",\"" + 1 + "\");'>激活</a>"
					}
				}
			}
		]],
		onDblClickRow: function (index, rowdata) {
			if ((index > -1) && (rowdata.IsActive != 0)) {
				$HUI.dialog('#LayerIExA').close();    	//关闭页面
				obj.IExAID = rowdata.IExAID;        	//更改评估表ID
                  
                obj.LoadEvent();
			}
		},
		rowStyler: function (index, row) {
			if (row.IsActive == 0) {
				return 'color:#bcb9b9;';
			}
			else {
				return 'color:black;';
			}
		},
	    onLoadSuccess: function (data) {
	        dispalyEasyUILoad(); 		//隐藏效果
	    }
	});
	//加载'患者'三管医嘱
	obj.gridHisOEOrdItem = $HUI.datagrid("#gridHisOEOrdItem", {
		fit: true,
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		fitColumns: true,
		loadMsg: '数据加载中...',
		columns: [[
			{ field: 'OeItemDesc', title: '医嘱名称', width: 150,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field: 'StartDt', title: '医嘱开始日期', width: 200,showTip:true,tipWidth:200,tipTrackMouse:true },
			{ field: 'EndDt', title: '医嘱结束日期', width: 200,showTip:true,tipWidth:200,tipTrackMouse:true},
			{ field: 'TypeValue', title: '医嘱类型', width: 120 }
		]],
	    onLoadSuccess: function (data) {
	       	dispalyEasyUILoad(); 		//隐藏效果
	  	}
	});
        
    InitIExARepWinEvent(obj);
    obj.LoadEvent();
    return obj;
}




