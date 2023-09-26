//消毒包维护界面js
function deleteItem(rowId) {
    if (isEmpty(rowId)) {
        $UI.msg('alert','请选择要删除的单据!');
        return false;
    }
    $.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
		if(data){
		    $.cm({
		        ClassName:'web.CSSDHUI.PackageInfo.PackageItem',
		        MethodName:'jsDelete',
		        rowId:rowId
		    },function(jsonData){
		        if(jsonData.success==0){
		            $UI.msg('success',jsonData.msg);
		            $('#ItemList').datagrid('reload');
		        }else{
		            $UI.msg('error',jsonData.msg);
		        }
		    });
		}
    })
}


function deleteMain(mainRowId,PackageType){
	if (isEmpty(mainRowId)) {
		$UI.msg('alert','请选择要删除的单据!');
		return false;
	}
	$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
		if(data){
			$.cm({
				ClassName:'web.CSSDHUI.PackageInfo.Package',
				MethodName:'DeleteMain',
				mainRowId:mainRowId,
				PackageType:PackageType
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#PackageList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		}
	});
}
//明细向上移动
function UpItem(ItemId,sort){  
    $.cm({
        ClassName: "web.CSSDHUI.PackageInfo.PackageItem",
        MethodName: "UpItem",
        ItemId:ItemId,
        sort:sort
    },function(jsonData){
        if(jsonData.success!=0){
            $UI.msg('error',jsonData.msg);
        }else{
            //$UI.msg('success',jsonData.msg);
            $('#ItemList').datagrid('reload');  
        }
    });         
}
//明细向下移动
function DownItem(ItemId,sort){ 
    $.cm({
        ClassName: "web.CSSDHUI.PackageInfo.PackageItem",
        MethodName: "DownItem",
        ItemId:ItemId,
        sort:sort
    },function(jsonData){
        if(jsonData.success!=0){
            $UI.msg('error',jsonData.msg);
        }else{
            //$UI.msg('success',jsonData.msg);
            $('#ItemList').datagrid('reload');  
        }
    });         
}
var init = function () {
	$('#PackType').combobox("setValue","");
	$('#PackTypeDetail').combobox("setValue","");
    ///===========================初始化条件======================
    var FPackageClassBox = $HUI.combobox('#PackClassDr', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
        valueField: 'RowId',
        textField: 'Description'
    });
    $('#QueryBT').on('click', QueryDrugInfo);
    $('#ClearBT').on('click', ClearDrugInfo);
    function QueryDrugInfo() {
        var Params=JSON.stringify($UI.loopBlock('#Conditions')); 
        MainGrid.load({
            ClassName: "web.CSSDHUI.PackageInfo.Package",
            QueryName: "getPackageInfo",
            Params:Params
        });
    }

    function ClearDrugInfo() {
        $UI.clearBlock('#Conditions');
        $UI.clear(MainGrid);
        $UI.clear(ItemListGrid);
    }
	$UI.linkbutton('#UpLoadViewPicBT', {   //上传图片
        onClick: function () {
            var row=MainGrid.getSelected();
            if(isEmpty(row)){
                $UI.msg('alert','请选择要上传图片的消毒包!');
                return;
            }
            var PackageRowid=row.RowId;
            var PackageName=row.Code;
			ViewPicUpLoader(PackageRowid,PackageName);
        }
    });
    
    $UI.linkbutton('#ViewPicBT', {   //浏览图片
        onClick: function () {
            var row=MainGrid.getSelected();
            if(isEmpty(row)){
                $UI.msg('alert','请选择要预览图片的消毒包!');
                return;
            }
            var PackageRowid=row.RowId;
			var PackageName=row.Code;
			ViewPic(PackageRowid,PackageName);
        }
    });
    ///=======================================maingrid start===========
    var LocParams =JSON.stringify(sessionObj);
    var LocCombox = {
        type: 'combobox',
        options: {
            url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
            valueField: 'RowId',
            textField: 'Description',
            onSelect: function (record) {
                var rows = MainGrid.getRows();
                var row = rows[MainGrid.editIndex];
                row.LocDesc = record.Description;
            },
            onShowPanel: function () {
                $(this).combobox('reload');
            }
        }
    };
    
	///消毒包单位    
	var UomData=$.cm({
	    ClassName: 'web.CSSDHUI.Common.Dicts',
	    QueryName: 'GetCTUom',
	    ResultSetType:"array"
	    },false);
	var UomCombox = {
	    type: 'combobox',
	    options: {
	        data:UomData,
	        valueField: 'RowId',
	        textField: 'Description',
	        onSelect: function (record) {
	            var rows = MainGrid.getRows();
	            var row = rows[MainGrid.editIndex];
	            row.UomDesc = record.Description;
	        },
	        onShowPanel: function () {
	            $(this).combobox('reload');
	        }
	    }
	};
	///消毒包分类
	PackClassDrCombox= {
	    type: 'combobox',
	    options: {
	        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
	        valueField: 'RowId',
	        textField: 'Description',
	        onSelect: function (record) {
	            var rows = MainGrid.getRows();
	            var row = rows[MainGrid.editIndex];
	            row.PackClassDrDesc = record.Description;
	        },
	        required: true,
	        //mode: 'remote',
	        onShowPanel: function () {
	            $(this).combobox('reload');
	        }
	    }
	};
	///灭菌方式
	SteTypeCombox= {
	    type: 'combobox',
	    options: {
	        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
	        valueField: 'RowId',
	        textField: 'Description',
	        onSelect: function (record) {
	            var rows = MainGrid.getRows();
	            var row = rows[MainGrid.editIndex];
	            row.SterTypeDesc = record.Description;
	        },
	        required: true,
	        //mode: 'remote',
	        onShowPanel: function () {
	            $(this).combobox('reload');
	        }
	    }
	};
	var NotUseFlagData=[{
	            "RowId":"Y",
	            "Description":"是"
	        },{
	            "RowId":"N",
	            "Description":"否"   
	        }]
	        
	NotUseFlagCombox= {
	    type: 'combobox',
	    options: {
	        data:NotUseFlagData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true
	    }
	};      
	
	var PackTypeData = [{
	            "RowId":1,
	            "Description":"循环包"
	        },{
	            "RowId":2,
	            "Description":"非循环包"
	        },{
	            "RowId":3,
	            "Description":"易损件"
	        },{
	            "RowId":4,
	            "Description":"包装容器"
	        }]
	
	PackTypeCombox= {
	    type: 'combobox',
	    options: {
	        data:PackTypeData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true,
	        required: true
	    }
	};
	var PackTypeDetailData = [{
	                "RowId":1,
	                "Description":"手术器械包"
	            },{
	                "RowId":2,
	                "Description":"普通包"
	            },{
	                "RowId":3,
	                "Description":"清洗筐"
	            },{
	                "RowId":4,
	                "Description":"清洗车"
	            },{
	                "RowId":5,
	                "Description":"灭菌筐"
	            },{
	                "RowId":6,
	                "Description":"灭菌车"
	            },{
	                "RowId":7,
	                "Description":"敷料包"
	            },{
	                "RowId":8,
	                "Description":"一次性"
	            },{
	                "RowId":9,
	                "Description":"急救包"
	            },{
					"RowId":10,
	                "Description":"专科器械包"
				}]
	PackTypeDetailCombox= {
	    type: 'combobox',
	    options: {
	        data:PackTypeDetailData,
	        valueField: 'RowId',
	        textField: 'Description',
	        editable:true,
	        required: true
	    }
	};

	/* var SterTypeData = [{
				"RowId":1,
				"Description":"低温灭菌"
			},{
				"RowId":0,
				"Description":"高温灭菌"
			}]
	
	SterTypeCombox= {
		type: 'combobox',
		options: {
			data:SterTypeData,
			valueField: 'RowId',
			textField: 'Description',
			editable:true,
			required: true
		}
	}; */
            
    var MainCm = [[
		{field:'operate',title:'操作',align:'center',width:100,
		formatter:function(value, row, index){
			var str = '<a href="#" name="opera" class="easyui-linkbutton" title="删除" onclick="deleteMain('+row.RowId+','+row.PackTypeDetail+')"></a>';
			return str;
		}},{
                title: 'id',
                field: 'RowId',
                align: 'left',
                width:100,
                hidden: true
            }, {
                title: '代码',
                field: 'Code',
                align: 'left',
                width:50,
                sortable: true,
                editor:{options:{required:true}}
            }, {
                title: '消毒包名称',
                field: 'Desc',
                align: 'left',
                width:200,
                sortable: true,
                editor:{type:'validatebox',options:{required:true}}
            }, {
                title: '别名',
                field: 'Alias',
                align: 'left',
                width:100,
                sortable: true
            }, {
                title: '单位',
                field: 'UomDr',
                align: 'left',
                width:100,
                sortable: true,
                formatter: CommonFormatter(UomCombox, 'UomDr', 'UomDesc'),
                editor: UomCombox
            }, {
                title: '消毒包类别',
                field: 'PackType',
                align: 'left',
                width:100,
                sortable: true,
                formatter: CommonFormatter(PackTypeCombox, 'PackType', 'PackTypeDesc'),
                editor: PackTypeCombox
            }, {
                title: '消毒包分类',
                field: 'PackClassDr',
                align: 'left',
                width:100,
                sortable: true,
                formatter: CommonFormatter(PackClassDrCombox, 'PackClassDr', 'PackClassDrDesc'),
                editor: PackClassDrCombox
            }, {
                title: '包属性',
                field: 'PackTypeDetail',
                align: 'left',
                width:100,
                sortable: true,
                formatter: CommonFormatter(PackTypeDetailCombox, 'PackTypeDetail', 'PackTypeDetailDesc'),
                editor: PackTypeDetailCombox
            }, {
                title: '单价',
                field: 'Price',
                align: 'right',
                width:100,
                sortable: true,
				editor:{type:'numberbox',options:{required:true,min:0}},
				formatter: function (value, row, index) {
					if (value != "") {
						return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
					}
				}
            }, {
                title: '循环次数',
                field: 'WorkTimes',
                align: 'right',
                width:100,
                sortable: true
            }, {
                title: '有效期',
                field: 'Length',
                align: 'right',
                width:100,
                sortable: true,
				editor:{type:'numberbox',options:{required:true,min:1}}
            }, {
                title: '科室',
                field: 'LocDr',
                align: 'left',
                width:100,
                sortable: true,
                formatter: CommonFormatter(LocCombox, 'LocDr', 'LocDesc'),
                editor: LocCombox
            }, {
                title: '备注',
                field: 'Remark',
                align: 'left',
                width:100,
                sortable: true,
                editor:{type:'validatebox'}
            },{
                title: '是否可用',
                field: 'NotUseFlag',
                width:100,
                align: 'center',
                sortable: true,
                formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
                editor: NotUseFlagCombox
            },{
                title: '灭菌方式',
                field: 'SterType',
                width:100,
                align: 'center',
                sortable: true,
                formatter: CommonFormatter(SteTypeCombox, 'SterType', 'SterTypeDesc'),
                editor: SteTypeCombox
            },{
                title: '是否启用生物监测',
                field: 'NotBioFlag',
                width:100,
                align: 'center',
                sortable: true,
                formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc'),
                editor: NotUseFlagCombox
            }
        ]];

    var MainGrid = $UI.datagrid('#PackageList', {
        queryParams: {
        ClassName: "web.CSSDHUI.PackageInfo.Package",
        QueryName: "getPackageInfo"
        },
        columns: MainCm,
		lazy:false,
		showBar:true,
		showAddSaveDelItems: true,
		singleSelect: true,
        saveDataFn: function(){
            var Rows=MainGrid.getChangesData();
            var Params2=JSON.stringify($UI.loopBlock('Conditions'))
            var Params=JSON.stringify(Rows)
			if(isEmpty(Rows)){
//				$UI.msg('alert','没有需要保存的信息!');
				return;
			}
            $.cm({
                ClassName: 'web.CSSDHUI.PackageInfo.Package',
                MethodName: 'SaveMain',
                Params: Params,
                Params2: Params2
            },function(jsonData){
                
                if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
                    MainGrid.reload();
                }else{
					$UI.msg('alert',jsonData.msg);
				}
            })
        },
		beforeDelFn:function(){
			var packageRow = $('#PackageList').datagrid('getSelected');
			if(!isEmpty(packageRow)){
				var packageRowid = packageRow.RowId;
				var PackageType = packageRow.PackTypeDetail;
				if (!isEmpty(packageRowid)) {
					deleteMain(packageRowid,PackageType);
				}
			}else{
				$UI.msg('alert','请选择要删除的单据!');
				return false;
			}
		},
        onClickCell: function(index, filed ,value){
            var Row=MainGrid.getRows()[index]
            var Id = Row.RowId;
            if(!isEmpty(Id)){
                FindItemByF(Id);
            }   
            MainGrid.commonClickCell(index,filed)
        },
        onLoadSuccess: function(data){
            if(data.rows.length > 0){
                $(this).datagrid('selectRow',0);
                FindItemByF(data.rows[0].RowId);
            }
        },
        onBeforeCellEdit: function(index, field){
            var RowData = $(this).datagrid('getRows')[index];
            if(field == 'WorkTimes' && !isEmpty(RowData['RowId'])){
                return false;
            }
        },
        onAfterEdit: function(rowIndex, rowData){
			if(!isEmpty(rowData.RowId)){
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
			}
		}
    });
	
	
	var ItemComData = $.cm({
		ClassName: 'web.CSSDHUI.Common.Dicts',
		QueryName: 'GetPackageItem',
		ResultSetType: 'array'
	},false);
	var ItemCombox = {
		type: 'combobox',
		options: {
			data: ItemComData,
			valueField: 'RowId',
			textField: 'Description',
			required: true
		},
        onBeforeLoad: function (param) {
            var Select = MainGrid.getSelected();
            if (!isEmpty(Select)) {
                $UI.msg('alert',Select);
            }
        }
    } 

    var ItemCm = [[
        {field:'operate',title:'操作',align:'center',width:110,
        formatter:function(value, row, index){
            var str = '<a href="#" name="opera" class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a> <a href="#" name="upi" class="easyui-linkbutton" title="上移" onclick="UpItem('+row.RowId+','+row.SerialNo+')"></a> <a href="#" name="downi" class="easyui-linkbutton" title="下移" onclick="DownItem('+row.RowId+','+row.SerialNo+')"></a>';
            return str;
    	}},{
            title: '序号',
            field: 'SerialNo',
            align: 'right',
            width:70
		},{
            title: 'RowId',
            field: 'RowId',
            width:100,
            hidden: true
        },{
            title: '器械名称',
            field: 'itmDr',
            width:150,
            formatter: CommonFormatter(ItemCombox, 'itmDr', 'Desc'),
            editor: ItemCombox
        },{
            title: '规格',
            field: 'Spec',
            width:80
        },{
            title: '数量',
            field: 'Qty',
            align: 'right',
            width:70,
			editor:{type:'numberbox',options:{required:true,min:1}}
        },{
			title: '是否启用',
			field: 'UseFlag',
			align: 'center',
			width:100,
			formatter: CommonFormatter(NotUseFlagCombox, 'NotUseFlag', 'NotUseFlagDesc')
		}
    ]]; 
    
    var ItemListGrid = $UI.datagrid('#ItemList', {
        queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			MethodName: 'SelectByF',
			rows:99999
        },
        columns: ItemCm,
        pagination:false,
        singleSelect:false,
        onLoadSuccess:function(data){ 
            $("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
            $("a[name='upi']").linkbutton({plain:true,iconCls:'icon-top-green'});
            $("a[name='downi']").linkbutton({plain:true,iconCls:'icon-down-blue'}); 
        },
        showAddSaveDelItems: true,
		saveDataFn:function(){      //保存明细
			var Rows=ItemListGrid.getChangesData();
			if(isEmpty(Rows)){
				//$UI.msg('alert','没有需要保存的信息!');
				return;
			}
			var PackageObj=MainGrid.getSelected();
			var PackageRowid=PackageObj.RowId
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
				MethodName: 'jsAddPackageDetail',
				Params: JSON.stringify(Rows),
				PackageRowid:PackageRowid
			},function(jsonData){
				$UI.msg('success',jsonData.msg);
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);                    
					ItemListGrid.reload();
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
		},
		beforeAddFn:function(){
			var rowMain = $('#PackageList').datagrid('getSelected');
			if(isEmpty(rowMain)){
				$UI.msg('alert','请选择消毒包再添加明细!');
				return false;
			}
		},
		beforeDelFn:function(){
			var rowItem = $('#ItemList').datagrid('getSelected');
			if(!isEmpty(rowItem)){
				if (!isEmpty(rowItem.RowId)) {
					var Rows=ItemListGrid.getSelectedData();
					$.messager.confirm("操作提示","您确定要执行删除操作吗？",function(data){	
						if(data){
							$.cm({
								ClassName:'web.CSSDHUI.PackageInfo.PackageItem',
								MethodName:'DeleteDetail',
								Params:JSON.stringify(Rows)
							},function(jsonData){
								if(jsonData.success==0){
									$UI.msg('success', jsonData.msg);
									ItemListGrid.reload();
								}else{
									$UI.msg('error', jsonData.msg);
								}
							});	
						}
					})
				}
			}else{
				$UI.msg('alert','请选择要删除的单据!');
				return false;
			}
		},
		onClickCell: function(index, field, value){
			ItemListGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var RowData = $(this).datagrid('getRows')[index];
			if(RowData['UseFlag']=="N"){
				$UI.msg('alert','该器械已停用，不可编辑!');
				return false;
			}
		},
		onAfterEdit:function(rowIndex,rowData){
			if(!isEmpty(rowData.RowId)){
				$("a[name='opera']").linkbutton({plain:true,iconCls:'icon-cancel'}); 
				$("a[name='upi']").linkbutton({plain:true,iconCls:'icon-top-green'});
				$("a[name='downi']").linkbutton({plain:true,iconCls:'icon-down-blue'}); 
			}
		}
	}); 
	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF',
			PackageRowId:Id,
			rows:99999
		});
	}
}
$(init);