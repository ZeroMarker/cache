//删除明细
function deleteItem(ItemRowId){
    var requiredDelete = RequiredDelete();
    if (requiredDelete == "Y"&&!isEmpty(ItemRowId)) {
        $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
            if(data){   
                $.cm({
                    ClassName:'web.CSSDHUI.CallBack.CallBackItm',
                    MethodName:'jsDelete',
                    rowId:ItemRowId
                },function(jsonData){
                    if(jsonData.success==0){
                        $UI.msg('success',jsonData.msg);
                        $('#ItemList').datagrid('reload');
						$('#ItemSList').datagrid('loadData',[]);
                    }else{
                        $UI.msg('error',jsonData.msg);
                    }
					
                });
            }
        });
	
    }
    if (requiredDelete != "Y") {
		$.cm({
			ClassName : 'web.CSSDHUI.CallBack.CallBackItm',
			MethodName : 'jsDelete',
			rowId : ItemRowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#ItemList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
}
//删除主表单据
//第一步:盘点单据是否可以删除
// 第二步删除主表单据
// 第三步删除子表数据 (包括修改打包表数据)目前的策略是:有明细不允许删除
function deleteMain(mainRowId){
    if (isEmpty(mainRowId)) {
            $UI.msg('alert','请选择要删除的单据!');
            return false;
        }
    $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
        if(data){   
            $.cm({
                ClassName:'web.CSSDHUI.CallBack.CallBack',
                MethodName:'jsDelete',
                mainRowId:mainRowId
            },function(jsonData){
                if(jsonData.success==0){
                    $UI.msg('success',jsonData.msg);
                    $('#MainList').datagrid('reload');
                    $('#ItemList').datagrid('reload');
                }else{
                    $UI.msg('alert',jsonData.msg);
                }
            });
        }
    });
}
//提交
var GridListIndex = "";
var GridListIndexId = ""
function submitOrder(mainRowId){
    if (isEmpty(mainRowId)) {
            $UI.msg('alert','请选择要提交的单据!');
            return false;
        }
        var Rows = $('#MainList').datagrid("getRows");
        $.each(Rows,function(index,item){
			if(item.RowId==mainRowId){
				GridListIndex=index;
				GridListIndexId=mainRowId;
			}
		});
        $.cm({
            ClassName:'web.CSSDHUI.CallBack.CallBack',
            MethodName:'jsSubmitOrder',
            mainRowId:mainRowId,
            gUser:gUserId
        },function(jsonData){
            if(jsonData.success==0){
                $UI.msg('success',jsonData.msg);
                $('#MainList').datagrid('reload');
            }else{
                $UI.msg('error',jsonData.msg);
            }
        });
}
//撤销
function cancelOrder(mainRowId){
    if (isEmpty(mainRowId)) {
            $UI.msg('alert','请选择要撤销的单据!');
            return false;
        }
    var requiredCancel = RequiredCancel();
    if (requiredCancel == "Y") {
        $.messager.confirm("操作提示","您确定要执行操作吗？",function(data){  
            if(data){
            	var Rows = $('#MainList').datagrid("getRows");
            	$.each(Rows,function(index,item){
					if(item.RowId==mainRowId){
						GridListIndex=index;
						GridListIndexId=mainRowId;
					}
				});
                $.cm({
                    ClassName:'web.CSSDHUI.CallBack.CallBack',
                    MethodName:'jsCancelOrder',
                    mainRowId:mainRowId
                },function(jsonData){
                    if(jsonData.success==0){
                        $UI.msg('success',jsonData.msg);
                        $('#MainList').datagrid('reload');
                    }else{
                        $UI.msg('error',jsonData.msg);
                    }
                });
            }
        });
    }
    if (requiredCancel != "Y") {
    	$.cm({
				ClassName:'web.CSSDHUI.CallBack.CallBack',
				MethodName:'jsCancelOrder',
				mainRowId:mainRowId
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
			});
    }
}
///======================================事件处理end=======================
var init = function() {
    var MainReqFlage="";
    //请求科室
    var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
    var ReqLocBox = $HUI.combobox('#ReqLoc', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
        valueField: 'RowId',
        textField: 'Description',
        onLoadSuccess: function (data) {   //默认登录科室
        //$("#ReqLoc").combobox('setValue',gLocId);
        }
    });
    //供应科室
    var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
    var SupLocBox = $HUI.combobox('#SupLoc', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
        valueField: 'RowId',
        textField: 'Description',
        onLoadSuccess: function (data) {   //默认第一个值
            $("#SupLoc").combobox('setValue',data[0].RowId);
        }
    });
    //回收人
    $("#toUser").keypress(function(event) {
      if ( event.which == 13 ) {
        var v=$("#toUser").val();
        var Ret = tkMakeServerCall('web.CSSDHUI.Common.Dicts', 'GetPersonInfo',v);
        if(Ret.split('^')[0]=="Y"){
            $("#toUser").val(Ret.split('^')[2]);
            $("#toUserDr").val(Ret.split('^')[1]);
            $("#SterUser").focus();
        }else{
            $UI.msg('alert','未找到相关信息!');
            $("#SterUser").val("");
            $("#SterUser").focus();
        }
       }
    });
    
    var Dafult={
		FStartDate:DefaultStDate(),
		FEndDate:DefaultEdDate
	}
    $UI.fillBlock('#MainCondition',Dafult)
    
    function Clear(){
        //$UI.clear(MainListGrid);
        $UI.clear(ItemListGrid);
        $UI.clear(ItemSListGrid);
    }
    ////===============================初始化组件end=============================
    //保存单据
    $UI.linkbutton('#SaveBT',{ 
        onClick:function(){
            saveMast();
        }
    });
    //更新单据的备注信息
	$UI.linkbutton('#UpdateBT',{
		onClick:function(){
			var Rows=MainListGrid.getChangesData();
			if(isEmpty(Rows)){
				$UI.msg('alert', '请选择需要保存的单据');
				return;
			}
			$.cm({
				ClassName:'web.CSSDHUI.CallBack.CallBack',
				MethodName:'JsUpdateRemark',
				Rows:JSON.stringify(Rows)	
			},function(jsonData){
				if(jsonData.success==0){
					$UI.msg('success',jsonData.msg);
					$('#MainList').datagrid('reload');
				}else{
					$UI.msg('error',jsonData.msg);
				}
				});
	}
	});
    
    function saveMast(){
        var MainObj = $UI.loopBlock('#MainCondition');
        var GridListIndex = "";
		var GridListIndexId = "";
        if(MainObj.fromLocDr==MainObj.toLocDr){
            $UI.msg('alert',"请领科室和供应科室不能相同");
            return;
        }
        if(isEmpty(MainObj.toUserDr)){
            $UI.msg('alert',"回收人不能为空");
            return;
        }
        if(isEmpty(MainObj.fromLocDr)){
            $UI.msg('alert',"申请科室不能为空");
            return;
        }
        $.cm({
				ClassName: 'web.CSSDHUI.CallBack.CallBack',
				MethodName: 'jsSave',
				Params: JSON.stringify(MainObj)
			},function(jsonData){
				$UI.msg('success',jsonData.msg);
				FindNew(jsonData.rowid);
			});
    }
    
    //生成请领单
    $UI.linkbutton('#CreateBT',{ 
        onClick:function(){
            SelReq(function(){MainListGrid.reload();});
        }
    });
    
    //查询
    $UI.linkbutton('#QueryBT',{ 
        onClick:function(){
        	Clear();
            FindWin(query);
        }
    });
     function query(ParamsObj) {
		var Params = JSON.stringify(ParamsObj);
		var GridListIndex = "";
		var GridListIndexId = "";
		MainListGrid.load({
			ClassName : 'web.CSSDHUI.CallBack.CallBack',
			QueryName : 'SelectAll',
			Params : Params,
			FIsOPRFlag : FIsOPRFlag
		});
	}
    // 打印单据
    $UI.linkbutton('#Print', {
        onClick: function () {
            var Detail = MainListGrid.getChecked();
            var DetailParams = JSON.stringify(Detail);
            if (isEmpty(Detail)) {
                $UI.msg('alert', '请选择需要打印单据');
            }
            if (!isEmpty(Detail)) {
                $.each(Detail, function (index, item) {
					PrintINCallBackReq(item.RowId);
                });
            }
            
        }
    });
    
    //上面输入框的回车事件处理 end
    var MainCm = [[{
				title : '',
				field : 'ck',
				checkbox : true,
				width : 50
			},
			{
        field:'operate',
        title:'操作',
        align:'center',
        width:100,
        formatter:function(value, row, index){
            if(row.ComplateFlag=="Y"){
                var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" disabled  onclick="deleteMain('+row.RowId+')"></a>';
                var str =str+ '<a href="#" name="operaR" class="easyui-linkbutton" title="撤销" onclick="cancelOrder('+row.RowId+')"></a>';
            }
            else {
                var str = '<a href="#" name="operaM" class="easyui-linkbutton" title="删除" onclick="deleteMain('+row.RowId+')"></a>';
                var str =str+ '<a href="#" name="operaC" class="easyui-linkbutton" title="提交" onclick="submitOrder('+row.RowId+')"></a>';
            }
            return str;
        }
    },{
            title: 'RowId',
            field: 'RowId',
            width:50,
            hidden: true
        }, {
            title: '单号',
            field: 'No',
            width:150,
            align: 'left',
            fitColumns:true
        }, {
            title: '申请科室',
            field: 'FroLocDesc',
            width:100,
            fitColumns:true
        }, {
            title: '是否提交',
            field: 'ComplateFlag',
            width:100,
            fitColumns:true,
            formatter:function(v){
                if(v=="Y")return "是";
                else return "否";
            }
        }, {
            title: '回收日期',
            field: 'CBDate',
            width:150,
            align: 'left',
            fitColumns:true
        },{
            title: '回收时间',
            field: 'CBTime',
            width:150,
            align: 'left',
            fitColumns:true
        }, {
            title: '回收人',
            field: 'ToUser',
            width:150,
            fitColumns:true
        }, {
            title: '提交日期',
            field: 'AckDate',
            width:150,
            align: 'left',
            fitColumns:true
        },{
            title: '提交人',
            field: 'AckUserDesc',
            width:117,
            fitColumns:true
        },{
			title: '备注',
			field: 'Remark',
			width:150,
			fitColumns:true,
			editor:{type:'validatebox'}
		}
    ]];
    var FIsOPRFlag = "N";
    var MainListGrid = $UI.datagrid('#MainList', {
        queryParams: {
            ClassName: 'web.CSSDHUI.CallBack.CallBack',
            QueryName: 'SelectAll'  ,
            Params:JSON.stringify($UI.loopBlock('#CondTB')),
            FIsOPRFlag:FIsOPRFlag
        },
        columns: MainCm,
        toolbar: '#CondTB',
        selectOnCheck: false,
        lazy: false,
        onLoadSuccess:function(data){  
                    $("a[name='operaM']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});  
                    $("a[name='operaC']").linkbutton({text:'',plain:true,iconCls:'icon-upload'});  
                    $("a[name='operaR']").linkbutton({text:'',plain:true,iconCls:'icon-back'});
                    if(data.rows.length>0&&isEmpty(GridListIndex)){
                        $('#MainList').datagrid("selectRow", 0);
                        FindItemByF(data.rows[0].RowId);
                    }
					if(!isEmpty(GridListIndex)){
						$('#MainList').datagrid("selectRow", GridListIndex);
						FindItemByF(GridListIndexId);
					}
            },
        onClickCell: function(index, filed ,value){
            var Row=MainListGrid.getRows()[index]
            var Id = Row.RowId;
            if(!isEmpty(Id)){
                FindItemByF(Id);
            }
            MainListGrid.commonClickCell(index,filed)
        }
    })
    
//========================================消毒包明细====start==============  
    //消毒包下拉列表
    var packData=$.cm({
        ClassName: 'web.CSSDHUI.Common.Dicts',
            QueryName: 'GetPackage' ,
            ResultSetType:"array",
            typeDetial: "2"
    },false);
    var PackageBox = {
        type: 'combobox',
        options: {
            data:packData,
            valueField: 'RowId',
            textField: 'Description',
            required:true,
            onSelect: function (record) {
                var rows = ItemListGrid.getRows();
                var row = rows[ItemListGrid.editIndex];
                row.PackageName = record.Description;
                var index = ItemListGrid.getRowIndex(row);
                for(var i=0;i<rows.length-1;i++){
                    if(rows[i].PackageName==record.Description&&(i!=index)){
                        $UI.msg('alert',"包名重复!");
                        $(this).combobox('clear');
                    }
                }
            },
            onShowPanel: function () {
                $(this).combobox('reload')
            }
        }
    };
    var ItemCm = [[
        {
            title: 'RowId',
            field: 'RowId',
            width:100,
            hidden: true
        },{
            title: 'ApplyDetailDr',
            field: 'ApplyDetailDr',
            width:100,
            hidden: true
        },{
            title: '消毒包名称',
            field: 'PackageDR',
            width:130,
            formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
            editor: PackageBox
        },{
            title: '回收数量',
            field: 'Qty',
            width:70,
            align: 'right',
            editor:{type:'numberbox',options:{required:true}}
        },{field:'operate',title:'操作',align:'center',width:80,
            formatter:function(value, row, index){
                var rowMain = $('#MainList').datagrid('getSelected');
                if(rowMain.ComplateFlag=="Y"){
                    var str = '<a href="#" name="opera"  disabled  class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
                }else{
                    var str = '<a href="#" name="opera"    class="easyui-linkbutton" title="删除" onclick="deleteItem('+row.RowId+')"></a>';
                }
                return str;
        }}
    ]]; 

    var ItemListGrid = $UI.datagrid('#ItemList', {
            queryParams: {
                ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
                MethodName: 'SelectByF'
            },
            columns: ItemCm,
            pagination:false,
            onLoadSuccess:function(data){  
				$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
				
				if(data.rows.length>0){
					$('#ItemList').datagrid("selectRow", 0);
					FindItemSByF(data.rows[0].PackageDR);
				}
            },
            showAddSaveDelItems: true,
            //showSaveItems:true,
            saveDataFn:function(){//保存明细
                var Rows=ItemListGrid.getChangesData(); 
                if(isEmpty(Rows)){
                    //$UI.msg('alert','没有需要保存的信息!');
                    return;
                }
                var rowMain = $('#MainList').datagrid('getSelected');
                $.cm({
                    ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
                    MethodName: 'jsSave',
                    Params: JSON.stringify(Rows),
                    MainId:rowMain.RowId
                },function(jsonData){
                    if(jsonData.success==0){
                    	$UI.msg('success',jsonData.msg);
                        ItemListGrid.reload();
                    }else{
                    	$UI.msg('alert',jsonData.msg);
                    }
                });
            },
            beforeDelFn:function(){
            	var ItemRowId="";
            	var rowMain = $('#ItemList').datagrid('getSelected');
            	if(!isEmpty(rowMain)){
            		ItemRowId = rowMain.RowId;
            	}
            	if (isEmpty(rowMain)) {
            		$UI.msg('alert','请选择要删除的单据!');
           		 	return false;
        		}	
        		var MainObj = $('#MainList').datagrid('getSelected');
            	if(MainObj.ComplateFlag == "N"){	
        			deleteItem(ItemRowId);
            	}else{
            		$UI.msg('alert',"单据已提交不能删除明细!");
            	}	
            },
            onClickCell: function(index, field, value){
                var Row=ItemListGrid.getRows()[index]
                var Id = Row.PackageDR;
                if(!isEmpty(Id)){
                    FindItemSByF(Id);
                }
                ItemListGrid.commonClickCell(index, field);
            },
            beforeAddFn:function(){
                var rowMain = $('#MainList').datagrid('getSelected');
                if(rowMain.ComplateFlag=="Y") return false;
            },
            onBeforeEdit:function(){
                var rowMain = $('#MainList').datagrid('getSelected');
                if(rowMain.ComplateFlag=="Y") return false;
            },onAfterEdit:function(){
            	$("a[name='opera']").linkbutton({text:'',plain:true,iconCls:'icon-cancel'});
            }
    }); 
    
    function FindItemByF(Id) {
        $UI.clear(ItemSListGrid);
        ItemListGrid.load({
            ClassName: 'web.CSSDHUI.CallBack.CallBackItm',
            QueryName: 'SelectByF',
            MainId:Id
        });
    }
//=========================消毒包明细end====================
//=========================器械明细==start======================
var ItemSCm = [[
        {
            title: 'RowId',
            field: 'RowId',
            width:100,
            hidden: true
        },{
            title: '器械名称',
            field: 'Desc',
            width:140,
            formatter: CommonFormatter(PackageBox, 'PackageDR', 'PackageName'),
            editor: PackageBox
        },{
            title: '规格',
            field: 'Spec',
            width:50
        },{
            title: '数量',
            field: 'Qty',
            align: 'right',
            width:49
        }
    ]]; 

    var ItemSListGrid = $UI.datagrid('#ItemSList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectByF'
		},
		columns: ItemSCm,
		pagination:false
    }); 
    ///根据消毒包dr查询包含的器械明细
    function FindItemSByF(Id) {
        ItemSListGrid.load({
            ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
            QueryName: 'SelectByF',
            PackageRowId:Id
        });
    }
//=========================器械明细 end========================
	function FindNew(Id){
		MainListGrid.load({
		ClassName: 'web.CSSDHUI.CallBack.CallBack',
		QueryName: 'FindNew',
		ID:Id
		});
	}
}
$(init);
