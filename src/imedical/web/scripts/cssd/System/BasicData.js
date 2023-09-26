var init = function() {
	var NotUseFlagData = [{ "RowId":"Y", "Description":"是"},{ "RowId":"N", "Description":"否"}]
	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	var IsSterData = [{ "RowId":"Y", "Description":"是"},{ "RowId":"N", "Description":"否"}]
	var IsSterCombox = {
		type: 'combobox',
		options: {
			data: IsSterData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
    //清洗方式----------------
	function CleanTypeSyn(){
        $.cm({
            ClassName: 'web.CSSDHUI.System.CleanType',
            MethodName: 'CleanTypeSyn'
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','参考值同步成功！');
                CleanModeGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    };
    var CleanModeGrid = $UI.datagrid('#CleanModeGrid',{
            queryParams: {
                ClassName: 'web.CSSDHUI.System.CleanType',
                QueryName: 'SelectAllCleanType'             
            },
  			beforeDelFn:function(){
 				var rowMain =  $('#CleanModeGrid').datagrid('getSelected');
 				if(!isEmpty(rowMain)){
 					var ID = rowMain.RowId
 				}
 				if(!isEmpty(rowMain)&&!isEmpty(ID)){
 					$UI.msg('alert','已维护清洗方式只能停用,不能删除');
 				}
			},
            /*deleteRowParams:{
                ClassName:'web.CSSDHUI.System.CleanType',
                MethodName:'jsDeleteCleanType'
            },*/
            //toolbar:[{
            //    text: '保存',
            //    iconCls: 'icon-save',
            //    handler: function () {
            //        SaveCleanMode();
            //}}],
            toolbar:[{
	            text: '参考值',
	            iconCls: 'icon-reload',
	            handler: function () {
	                CleanTypeSyn();
        		}}
        	],
            saveDataFn:function SaveCleanMode(){
                var Rows=CleanModeGrid.getChangesData();
                if(isEmpty(Rows)){
                    //$UI.msg('alert','没有需要保存的信息!');
                    return;
                }
                $.cm({
                    ClassName: 'web.CSSDHUI.System.CleanType',
                    MethodName: 'SaveCleanType',
                    Params: JSON.stringify(Rows)
                },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success','保存成功！');
                    CleanModeGrid.reload();
                }else{
                    $UI.msg('error',jsonData.msg);
                }
            });
            },
            columns: [[{
                    title: 'RowId',
                    field: 'RowId',
                    width:150,
                    hidden: true
                }, {
                    title: '清洗编码',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '清洗方式',
                    field: 'Description',
                    width:150,
                    editor:{type:'validatebox',options:{required:true}}
				},{
					title:'是否启用',
					align:'center',
					field:'IsUsed',
					width:100,
					formatter: CommonFormatter(NotUseFlagCombox,'IsUsed','IsUsedDesc'),
					editor:NotUseFlagCombox
				}
            ]],
            lazy:false,
            showAddSaveDelItems:true,
            pagination:false,
            onClickCell: function(index, filed ,value){
                CleanModeGrid.commonClickCell(index,filed)
                }
        });
    //清洗程序--------------------------
    
    var CleanSystemGrid = $UI.datagrid('#CleanSystemGrid',{
            queryParams: {
                ClassName: 'web.CSSDHUI.System.CleanProcedures',
                QueryName: 'SelectAllCleanProcedures'               
            },
			beforeDelFn:function(){
 				var rowMain =  $('#CleanSystemGrid').datagrid('getSelected');
 				if(!isEmpty(rowMain)){
 					var ID = rowMain.RowId
 				}
 				if(!isEmpty(rowMain)&&!isEmpty(ID)){
 					$UI.msg('alert','已维护清洗程序只能停用,不能删除');
 				}
			},
            /*deleteRowParams:{
                ClassName:'web.CSSDHUI.System.CleanProcedures',
                MethodName:'jsDeleteCleanProcedures'
            },*/
            saveDataFn:function SaveCleanSystem(){
				var Rows=CleanSystemGrid.getChangesData();
				if(isEmpty(Rows)){
					//$UI.msg('alert','没有需要保存的信息!');
					return;
				}
				$.cm({
					ClassName: 'web.CSSDHUI.System.CleanProcedures',
					MethodName: 'SaveCleanProcedures',
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success','保存成功！');
						CleanSystemGrid.reload();
					}else{
						$UI.msg('error',jsonData.msg);
					}
				});
	},
            columns: [[{
                    title: 'RowId',
                    field: 'RowId',
                    hidden: true
                }, {
                    title: '清洗代码',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '清洗程序描述',
                    field: 'Description',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },
                {
                    title: '条形码',
                    align:'left',
                    field: 'BegLabel',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },{
					title:'是否启用',
					align:'center',
					field:'NotUseFlag',
					width:100,
					formatter: CommonFormatter(NotUseFlagCombox,'NotUseFlag','NotUseFlagDesc'),
					editor:NotUseFlagCombox
				}
            ]],
            lazy:false,
            showAddSaveDelItems:true,
            pagination:false,
            onClickCell: function(index, filed ,value){
                CleanSystemGrid.commonClickCell(index,filed)
            }
        }); 
        
    //灭菌方式----------------
    var SterModeGrid = $UI.datagrid('#SterModeGrid',{
            queryParams: {
                ClassName: 'web.CSSDHUI.System.SterType',
                QueryName: 'SelectAllSterType'             
            },
  			beforeDelFn:function(){
 				var rowMain =  $('#SterModeGrid').datagrid('getSelected');
 				if(!isEmpty(rowMain)){
 					var ID = rowMain.RowId
 				}
 				if(!isEmpty(rowMain)&&!isEmpty(ID)){
 					$UI.msg('alert','已维护灭菌方式只能停用,不能删除');
 				}
			},
            saveDataFn:function SaveSterMode(){
                var Rows=SterModeGrid.getChangesData();
                if(isEmpty(Rows)){
                    //$UI.msg('alert','没有需要保存的信息!');
                    return;
                }
                $.cm({
                    ClassName: 'web.CSSDHUI.System.SterType',
                    MethodName: 'SaveSterType',
                    Params: JSON.stringify(Rows)
                },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success','保存成功！');
                    SterModeGrid.reload();
                }else{
                    $UI.msg('error',jsonData.msg);
                }
            });
            },
            columns: [[{
                    title: 'RowId',
                    field: 'RowId',
                    width:150,
                    hidden: true
                }, {
                    title: '灭菌编码',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '灭菌方式',
                    field: 'Description',
                    width:150,
                    editor:{type:'validatebox',options:{required:true}}
				},{
					title:'是否启用',
					align:'center',
					field:'IsUsed',
					width:100,
					formatter: CommonFormatter(NotUseFlagCombox,'IsUsed','IsUsedDesc'),
					editor:NotUseFlagCombox
				},{
					title: '是否需要灭菌',
                    field: 'IsSter',
					width:120,
                    formatter: CommonFormatter(IsSterCombox,'IsSter','IsSterDesc'),
					editor:IsSterCombox
				},{
					title: '是否低温灭菌',
					field: 'IsLowerTemp',
					width:120,
					formatter: CommonFormatter(IsSterCombox,'IsLowerTemp','IsLowerTempDesc'),
					editor:IsSterCombox
				}
            ]],
            lazy:false,
            showAddSaveDelItems:true,
            pagination:false,
            onClickCell: function(index, filed ,value){
				SterModeGrid.commonClickCell(index,filed)
			}
        });    
        
    //灭菌程序--------------------------
	///灭菌方式下拉数据
	var TempTypeCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array&isSter=Y',
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = SterilizationSysGrid.getRows();
				var row = rows[SterilizationSysGrid.editIndex];
				row.SterWayDesc = record.Description;
			}
		}
	};
    
    var SterilizationSysGrid = $UI.datagrid('#SterilizationSysGrid',{
            queryParams: {
                ClassName: 'web.CSSDHUI.System.SterilizationSys',
                QueryName: 'SelectAllSterilizationSys'              
            },
            saveDataFn:function SaveSterilizationSys(){
        var Rows=SterilizationSysGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','没有需要保存的信息!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.SterilizationSys',
            MethodName: 'SaveSterilizationSys',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','保存成功！');
                SterilizationSysGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    },
            columns: [[{
                    title: 'RowId',
                    field: 'RowId',
                    hidden: true
                }, {
                    title: '灭菌代码',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },
                 {
                    title: '灭菌程序名称',
                    field: 'Description',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '条形码',
                    align:'left',
                    field: 'BegLabel',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '灭菌方式',
                    align:'left',
                    field: 'SterWay',
                    width:100,
                    formatter: CommonFormatter(TempTypeCombox, 'SterWay', 'SterWayDesc'),
					editor: TempTypeCombox
                }, {
	                title: '是否启用',
	                field: 'NotUseFlag',
	                width:100,
	                align: 'center',
	                formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
	                editor: NotUseFlagCombox
            	}
            ]],
            lazy:false,
            showAddSaveDelItems:true,
            pagination:false,
            beforeDelFn:function(){
	        	var rowMain = $('#SterilizationSysGrid').datagrid('getSelected');
	        	if(!isEmpty(rowMain)){
	        		var Id = rowMain.RowId
	        	}
	        	if(!isEmpty(rowMain)&&!isEmpty(Id)){
	        		$UI.msg('alert','已维护灭菌程序只能停用,不能删除');
	        	}
        	},
            onClickCell: function(index, filed ,value){
                SterilizationSysGrid.commonClickCell(index,filed)
            }
        });
        //灭菌不合格原因----------------
    function ReasonForSteriFailSyn(){
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
            MethodName: 'ReasonForSteriFailSyn'
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','参考值同步成功！');
                ReasonForSteriFailGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    };
    var ReasonForSteriFailGrid = $UI.datagrid('#ReasonForSteriFailGrid',{
        queryParams: {
            ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
            QueryName: 'SelectAllReasonForSteriFail'                
        },
        toolbar:[{
            text: '参考值',
            iconCls: 'icon-reload',
            handler: function () {
                ReasonForSteriFailSyn();
        }}],
        saveDataFn:function SaveReasonForSteriFail(){
        var Rows=ReasonForSteriFailGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','没有需要保存的信息!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
            MethodName: 'SaveReasonForSteriFail',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','保存成功！');
                ReasonForSteriFailGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    },
        columns: [[{
                title: 'RowId',
                field: 'RowId',
                width:100,
                hidden:true
            }, {
                title: '灭菌不合格代码',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '灭菌不合格原因',
                field: 'Description',
                width:200,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '是否启用',
                field: 'NotUseFlag',
                width:100,
                align: 'center',
                formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
                editor: NotUseFlagCombox
            }
        ]],
        lazy:false,
        showAddSaveDelItems:true,
        pagination:false,
        beforeDelFn:function(){
        	var rowMain = $('#ReasonForSteriFailGrid').datagrid('getSelected');
        	if(!isEmpty(rowMain)){
        		var Id = rowMain.RowId
        	}
        	if(!isEmpty(rowMain)&&!isEmpty(Id)){
        		$UI.msg('alert','已维护灭菌不合格原因只能停用,不能删除');
        	}
        },
        onClickCell: function(index, filed ,value){
            ReasonForSteriFailGrid.commonClickCell(index,filed)
        }
    });
            //清洗不合格原因原因----------------
    
    var ReasonForCleanFailGrid = $UI.datagrid('#ReasonForCleanFailGrid',{
        queryParams: {
            ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
            QueryName: 'SelectAllReasonForCleanFail'                
        },
        beforeDelFn:function(){
 				var rowMain =  $('#ReasonForCleanFailGrid').datagrid('getSelected');
 				if(!isEmpty(rowMain)){
 					var ID = rowMain.RowId
 				}
 				if(!isEmpty(rowMain)&&!isEmpty(ID)){
 					$UI.msg('alert','已维护清洗不合格原因只能停用,不能删除');
 				}
		},
        /*deleteRowParams:{
            ClassName:'web.CSSDHUI.System.ReasonForCleanFail',
            MethodName:'jsDeleteReasonForCleanFail'
        },*/
        saveDataFn:function SaveReasonForCleanFail(){
        var Rows=ReasonForCleanFailGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','没有需要保存的信息!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
            MethodName: 'SaveReasonForCleanFail',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','保存成功！');
                ReasonForCleanFailGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    },
        columns: [[{
                title: 'RowId',
                field: 'RowId',
                width:100,
                hidden:true
            },{
                title: '清洗不合格代码',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '清洗不合格原因',
                field: 'Description',
                width:150,
                editor:{type:'validatebox',options:{required:true}}
            },{
				title:'是否启用',
				align:'center',
				field:'NotUseFlag',
				width:100,
				formatter: CommonFormatter(NotUseFlagCombox,'NotUseFlag','NotUseFlagDesc'),
				editor:NotUseFlagCombox
				}
        ]],
        lazy:false,
        showAddSaveDelItems:true,
        pagination:false,
        onClickCell: function(index, filed ,value){
            ReasonForCleanFailGrid.commonClickCell(index,filed)
        }
    });
    
    //器械缺失原因----------------
    
    var ReasonForConsumeGrid = $UI.datagrid('#ReasonForConsumeGrid',{
        queryParams: {
            ClassName: 'web.CSSDHUI.System.ReasonForConsume',
            QueryName: 'SelectAllReasonForConsume'                
        },
        saveDataFn:function SaveReasonForConsume(){
        var Rows=ReasonForConsumeGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','没有需要保存的信息!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForConsume',
            MethodName: 'SaveReasonForConsume',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','保存成功！');
                ReasonForConsumeGrid.reload();
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
    },
        columns: [[{
                title: 'RowId',
                field: 'RowId',
                width:100,
                hidden:true
            },{
                title: '缺失原因代码',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '缺失原因',
                field: 'Description',
                width:150,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '是否启用',
                field: 'NotUseFlag',
                width:100,
                align: 'center',
                formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
                editor: NotUseFlagCombox
            }
        ]],
        lazy:false,
        showAddSaveDelItems:true,
        pagination:false,
        beforeDelFn:function(){
        	var rowMain = $('#ReasonForConsumeGrid').datagrid('getSelected');
        	if(!isEmpty(rowMain)){
        		var Id = rowMain.RowId
        	}
        	if(!isEmpty(rowMain)&&!isEmpty(Id)){
        		$UI.msg('alert','已维护缺失原因只能停用,不能删除');
        	}
        },
        onClickCell: function(index, filed ,value){
            ReasonForConsumeGrid.commonClickCell(index,filed)
        }
    });
    
            //供应中心----------------
    //科室
    var CtLocData = $.cm({
        ClassName: 'web.CSSDHUI.Common.Dicts',
        QueryName: 'GetCTLoc',
        ResultSetType: 'array'
    },false);
    var CtLocBox = {
        type: 'combobox',
        options: {
            data: CtLocData,
            valueField: 'RowId',
            textField: 'Description',
            onSelect: function(record){
        }
        }
    } 
    
    var SupplyCenterGrid = $UI.datagrid('#SupplyCenterGrid',{
            queryParams: {
                ClassName: 'web.CSSDHUI.System.SupplyCenter',
                QueryName: 'SelectAllSupplyCenter'              
            },
            deleteRowParams:{
                ClassName:'web.CSSDHUI.System.SupplyCenter',
                MethodName:'jsDeleteSupplyCenter'
            },
            saveDataFn:function SaveSupplyCenter(){
                var Rows=SupplyCenterGrid.getChangesData();
                $.cm({
                    ClassName: 'web.CSSDHUI.System.SupplyCenter',
                    MethodName: 'SaveSupplyCenter',
                    Params: JSON.stringify(Rows)
                },function(jsonData){
                if(jsonData.success==0){
					if(isEmpty(Rows)){
						//$UI.msg('alert','没有需要保存的信息!');
						return;
					}
                    $UI.msg('success','保存成功！');
                    SupplyCenterGrid.reload();
                }else{
                    $UI.msg('error',jsonData.msg);
                }
            });
            },
            columns: [[
                {
                    title: 'RowId',
                    field: 'RowId',
                    width:100,
                    saveCol: true,
                    hidden:true
                },{
                    title: '科室代码',
                    field: 'Code',
                    width:100,
                    editorable:false
                }, {
                    title: '科室描述',
                    field: 'LocId',
                    width:150,
                    saveCol: true,
                    formatter: CommonFormatter(CtLocBox,'LocId','Description'),
                    editor:CtLocBox
                }
            ]],
            singleSelect: false,
            lazy:false,
            showAddSaveDelItems:true,
            pagination:false,
            onClickCell: function(index, filed ,value){
                SupplyCenterGrid.commonClickCell(index,filed)
            }
        });
}
$(init)