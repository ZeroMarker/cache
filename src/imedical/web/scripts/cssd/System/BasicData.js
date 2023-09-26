var init = function() {
	var NotUseFlagData = [{ "RowId":"Y", "Description":"��"},{ "RowId":"N", "Description":"��"}]
	var NotUseFlagCombox = {
		type: 'combobox',
		options: {
			data: NotUseFlagData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
	var IsSterData = [{ "RowId":"Y", "Description":"��"},{ "RowId":"N", "Description":"��"}]
	var IsSterCombox = {
		type: 'combobox',
		options: {
			data: IsSterData,
			valueField: 'RowId',
			textField: 'Description'
		}
	}
    //��ϴ��ʽ----------------
	function CleanTypeSyn(){
        $.cm({
            ClassName: 'web.CSSDHUI.System.CleanType',
            MethodName: 'CleanTypeSyn'
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','�ο�ֵͬ���ɹ���');
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
 					$UI.msg('alert','��ά����ϴ��ʽֻ��ͣ��,����ɾ��');
 				}
			},
            /*deleteRowParams:{
                ClassName:'web.CSSDHUI.System.CleanType',
                MethodName:'jsDeleteCleanType'
            },*/
            //toolbar:[{
            //    text: '����',
            //    iconCls: 'icon-save',
            //    handler: function () {
            //        SaveCleanMode();
            //}}],
            toolbar:[{
	            text: '�ο�ֵ',
	            iconCls: 'icon-reload',
	            handler: function () {
	                CleanTypeSyn();
        		}}
        	],
            saveDataFn:function SaveCleanMode(){
                var Rows=CleanModeGrid.getChangesData();
                if(isEmpty(Rows)){
                    //$UI.msg('alert','û����Ҫ�������Ϣ!');
                    return;
                }
                $.cm({
                    ClassName: 'web.CSSDHUI.System.CleanType',
                    MethodName: 'SaveCleanType',
                    Params: JSON.stringify(Rows)
                },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success','����ɹ���');
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
                    title: '��ϴ����',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '��ϴ��ʽ',
                    field: 'Description',
                    width:150,
                    editor:{type:'validatebox',options:{required:true}}
				},{
					title:'�Ƿ�����',
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
    //��ϴ����--------------------------
    
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
 					$UI.msg('alert','��ά����ϴ����ֻ��ͣ��,����ɾ��');
 				}
			},
            /*deleteRowParams:{
                ClassName:'web.CSSDHUI.System.CleanProcedures',
                MethodName:'jsDeleteCleanProcedures'
            },*/
            saveDataFn:function SaveCleanSystem(){
				var Rows=CleanSystemGrid.getChangesData();
				if(isEmpty(Rows)){
					//$UI.msg('alert','û����Ҫ�������Ϣ!');
					return;
				}
				$.cm({
					ClassName: 'web.CSSDHUI.System.CleanProcedures',
					MethodName: 'SaveCleanProcedures',
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success','����ɹ���');
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
                    title: '��ϴ����',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '��ϴ��������',
                    field: 'Description',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },
                {
                    title: '������',
                    align:'left',
                    field: 'BegLabel',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },{
					title:'�Ƿ�����',
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
        
    //�����ʽ----------------
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
 					$UI.msg('alert','��ά�������ʽֻ��ͣ��,����ɾ��');
 				}
			},
            saveDataFn:function SaveSterMode(){
                var Rows=SterModeGrid.getChangesData();
                if(isEmpty(Rows)){
                    //$UI.msg('alert','û����Ҫ�������Ϣ!');
                    return;
                }
                $.cm({
                    ClassName: 'web.CSSDHUI.System.SterType',
                    MethodName: 'SaveSterType',
                    Params: JSON.stringify(Rows)
                },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success','����ɹ���');
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
                    title: '�������',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '�����ʽ',
                    field: 'Description',
                    width:150,
                    editor:{type:'validatebox',options:{required:true}}
				},{
					title:'�Ƿ�����',
					align:'center',
					field:'IsUsed',
					width:100,
					formatter: CommonFormatter(NotUseFlagCombox,'IsUsed','IsUsedDesc'),
					editor:NotUseFlagCombox
				},{
					title: '�Ƿ���Ҫ���',
                    field: 'IsSter',
					width:120,
                    formatter: CommonFormatter(IsSterCombox,'IsSter','IsSterDesc'),
					editor:IsSterCombox
				},{
					title: '�Ƿ�������',
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
        
    //�������--------------------------
	///�����ʽ��������
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
            //$UI.msg('alert','û����Ҫ�������Ϣ!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.SterilizationSys',
            MethodName: 'SaveSterilizationSys',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','����ɹ���');
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
                    title: '�������',
                    align:'left',
                    field: 'Code',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                },
                 {
                    title: '�����������',
                    field: 'Description',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '������',
                    align:'left',
                    field: 'BegLabel',
                    width:100,
                    editor:{type:'validatebox',options:{required:true}}
                }, {
                    title: '�����ʽ',
                    align:'left',
                    field: 'SterWay',
                    width:100,
                    formatter: CommonFormatter(TempTypeCombox, 'SterWay', 'SterWayDesc'),
					editor: TempTypeCombox
                }, {
	                title: '�Ƿ�����',
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
	        		$UI.msg('alert','��ά���������ֻ��ͣ��,����ɾ��');
	        	}
        	},
            onClickCell: function(index, filed ,value){
                SterilizationSysGrid.commonClickCell(index,filed)
            }
        });
        //������ϸ�ԭ��----------------
    function ReasonForSteriFailSyn(){
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
            MethodName: 'ReasonForSteriFailSyn'
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','�ο�ֵͬ���ɹ���');
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
            text: '�ο�ֵ',
            iconCls: 'icon-reload',
            handler: function () {
                ReasonForSteriFailSyn();
        }}],
        saveDataFn:function SaveReasonForSteriFail(){
        var Rows=ReasonForSteriFailGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','û����Ҫ�������Ϣ!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForSteriFail',
            MethodName: 'SaveReasonForSteriFail',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','����ɹ���');
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
                title: '������ϸ����',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '������ϸ�ԭ��',
                field: 'Description',
                width:200,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '�Ƿ�����',
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
        		$UI.msg('alert','��ά��������ϸ�ԭ��ֻ��ͣ��,����ɾ��');
        	}
        },
        onClickCell: function(index, filed ,value){
            ReasonForSteriFailGrid.commonClickCell(index,filed)
        }
    });
            //��ϴ���ϸ�ԭ��ԭ��----------------
    
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
 					$UI.msg('alert','��ά����ϴ���ϸ�ԭ��ֻ��ͣ��,����ɾ��');
 				}
		},
        /*deleteRowParams:{
            ClassName:'web.CSSDHUI.System.ReasonForCleanFail',
            MethodName:'jsDeleteReasonForCleanFail'
        },*/
        saveDataFn:function SaveReasonForCleanFail(){
        var Rows=ReasonForCleanFailGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','û����Ҫ�������Ϣ!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForCleanFail',
            MethodName: 'SaveReasonForCleanFail',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','����ɹ���');
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
                title: '��ϴ���ϸ����',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '��ϴ���ϸ�ԭ��',
                field: 'Description',
                width:150,
                editor:{type:'validatebox',options:{required:true}}
            },{
				title:'�Ƿ�����',
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
    
    //��еȱʧԭ��----------------
    
    var ReasonForConsumeGrid = $UI.datagrid('#ReasonForConsumeGrid',{
        queryParams: {
            ClassName: 'web.CSSDHUI.System.ReasonForConsume',
            QueryName: 'SelectAllReasonForConsume'                
        },
        saveDataFn:function SaveReasonForConsume(){
        var Rows=ReasonForConsumeGrid.getChangesData();
        if(isEmpty(Rows)){
            //$UI.msg('alert','û����Ҫ�������Ϣ!');
            return;
        }
        $.cm({
            ClassName: 'web.CSSDHUI.System.ReasonForConsume',
            MethodName: 'SaveReasonForConsume',
            Params: JSON.stringify(Rows)
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success','����ɹ���');
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
                title: 'ȱʧԭ�����',
                align:'left',
                field: 'Code',
                width:120,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: 'ȱʧԭ��',
                field: 'Description',
                width:150,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '�Ƿ�����',
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
        		$UI.msg('alert','��ά��ȱʧԭ��ֻ��ͣ��,����ɾ��');
        	}
        },
        onClickCell: function(index, filed ,value){
            ReasonForConsumeGrid.commonClickCell(index,filed)
        }
    });
    
            //��Ӧ����----------------
    //����
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
						//$UI.msg('alert','û����Ҫ�������Ϣ!');
						return;
					}
                    $UI.msg('success','����ɹ���');
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
                    title: '���Ҵ���',
                    field: 'Code',
                    width:100,
                    editorable:false
                }, {
                    title: '��������',
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