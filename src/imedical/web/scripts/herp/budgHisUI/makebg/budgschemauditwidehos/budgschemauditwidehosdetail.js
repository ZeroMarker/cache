Detail = function(){
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];   
    //科目分类
    var DItemTypeObj = $HUI.combobox("#DItemType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:function(data){  
        	var Code="",Year=""
        	var row = $('#MainGrid').datagrid('getSelected');
        	if(row!=""){
            	Year=row.bsmyear;
            	Code=row.bsmcode;
        	
        		//var DItemType= $('#DItemType').combobox('getValue');// 科目类别
        		var DItemCode= $('#DItemBox').val(); 
        		var DLevel = $('#DItemLevel').checkbox('getValue'); 
        		
        		var IsLast = $('#IsLastBox').checkbox('getValue'); 
        		if(IsLast == true){
            		IsLast=1;
        		}else{
            		IsLast=0;
        		}
        		DetailGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
                	MethodName:"ListDetail",
                	hospid :    hospid, 
                	islast :    IsLast,
                	Code   :    Code,
                	Year   :    Year,
                	BSDCode:	DItemCode,
                	BITName :   data.code  ,
                	DLevel:		DLevel
            	})
            }
     	}
    });
    //科目级别
    var DItemLevelObj = $HUI.combobox("#DItemLevel",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemLev",
        mode:'remote',
        delay:200,
        valueField:'level',    
        textField:'level',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.userid = userid; 
            param.hospid = hospid;
            param.year =$('#YBox').combobox('getValue') ;
        },
        onSelect:function(data){  
        	var Code="",Year=""
        	var row = $('#MainGrid').datagrid('getSelected');
        	if(row!=""){
            	Year=row.bsmyear;
            	Code=row.bsmcode;
        	
        		var DItemType= $('#DItemType').combobox('getValue');// 科目类别
        		var DItemCode= $('#DItemBox').val(); 
        		//var DLevel = $('#DItemLevel').checkbox('getValue'); 
        		
        		var IsLast = $('#IsLastBox').checkbox('getValue'); 
        		if(IsLast == true){
            		IsLast=1;
        		}else{
            		IsLast=0;
        		}
        		DetailGridObj.load({
                	ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
                	MethodName:"ListDetail",
                	hospid :    hospid, 
                	islast :    IsLast,
                	Code   :    Code,
                	Year   :    Year,
                	BSDCode:	DItemCode,
                	BITName :   DItemType  ,
                	DLevel:		data.level
            	})
            }
     	}
    });
    
     //是否末级
    $("#IsLastBox").checkbox({
        onCheckChange:function(event,value){
	        if(value == true){
	        	value=1;
	       	}else{
		       	value=0;
		   	}		   

        	var Code="",Year=""
        	var row = $('#MainGrid').datagrid('getSelected');
        	if(row!=""){
            	Year=row.bsmyear;
            	Code=row.bsmcode;
        		var DItemType= $('#DItemType').combobox('getValue');// 科目类别
        		var DItemCode= $('#DItemBox').val(); 
        		var DLevel = $('#DItemLevel').checkbox('getValue');
        		DetailGridObj.load({
               		ClassName:"herp.budg.hisui.udata.uBudgSchemWideHos",
                	MethodName:"ListDetail",
                	hospid :    hospid, 
                	islast :    value,
                	Code   :    Code,
                	Year   :    Year,
                	BSDCode:    DItemCode ,
                	BITName :   DItemType,
                	DLevel:		DLevel  
            })
            }
        }
    })
    
    DetailColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'bsdcode',title:'科目编码',width:100},
                {field:'bidname',title:'科目名称',width:160},
                {field:'bfhisvalue',title:'参考数据',width:120,align:'right',formatter:dataFormat},
                {field:'bfrealvaluelast',title:'上年执行',width:120,align:'right',formatter:dataFormat},
                {field:'bfplanvalue',title:'本年度预算',width:120,align:'right',formatter:dataFormat,
                    styler: function(value,row,index){
                        var mod = row.bideditmod;
                        var step = row.bsachkstep;
                        if (((mod == "1") || (mod == "3")) && ((step == "0") || (step == ""))) {
                            return 'background-color:#EEEEEE;color:brown;cursor:hand';
                        } else {
                            return 'color:black;cursor:hand';
                        }
                    },
                    editor: { type: 'numberbox', options: { precision:2} },allowBlank:false},
                {field:'sf',title:'差额',width:120,align:'right',formatter:dataFormat},
                {field:'scf',title:'差额率(%)',width:80,align:'right'},
                {field:'bfplanvaluemodimid',title:'修改中间数',width:120,align:'right',formatter:dataFormat},
                {field:'bsdcalflag',title:'编制方法',width:150,
                    formatter:function(value,row,index){
                        if (value == 1) {
                            return '<span>公式计算-按计算公式字段中定义的公式计算数据</span>';
                        } else if(value == 2) {
                            return '<span>历史数据*比例系数</span>';
                        }else if(value == 3) {
                            return '<span>历史数据</span>';
                        }
                    }
                },
                {field:'bideditmod',title:'编制模式',width:80,
                    formatter:function(value,row,index){
                        if (value == 1) {
                            return '<span>自上而下</span>';
                        } else if(value == 2) {
                            return '<span>自下而上</span>';
                        }else if(value == 3) {
                            return '<span>上下结合</span>';
                        }
                    }
                },
                {field:'bfchkdesc',title:'审批意见',width:80,hidden: true},
                {field:'bsdcaldesc',title:'参考方法',width:80},
                {field:'bsachkstep',title:'审核步骤',width:80}
            ]];
    var DetailGridObj = $HUI.datagrid("#DetailGrid",{
        url:$URL/*,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
            MethodName:"ListDetail",
            hospid :    hospid, 
            BIDLevel :    "",
            Code   :    "",
            Year   :    "",
            BSDCode:   "" ,
            BITName :   "",
            DLevel:		""         
        }*/,
        delay:200,
        fitColumns: false,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:DetailColumns,
        onClickCell: function(index,field,value){
            if(field=='bfplanvalue'){
                var selectedRow = $('#MainGrid').datagrid('getSelected');
                var rows = $('#DetailGrid').datagrid('getRows');
                if(selectedRow==null){
                    $.messager.alert('提示','请选择方案！','info');
                }
                // console.log(selectedRow.bsarstepno+"^"+selectedRow.StepNO+"^"+selectedRow.basriscurstep+"^"+rows[index].IsLast)
                if ((selectedRow.basriscurstep == 1) && (selectedRow.bsarstepno == selectedRow.StepNO)&&(rows[index].IsLast == '1')) {
                    $('#DetailGrid').datagrid('beginEdit', index);
                }
            }
        },
        toolbar: '#dtb'       
    });    
    // 查询函数
    var DFindBtn= function()
    {
        var Code="",Year=""
        var row = $('#MainGrid').datagrid('getSelected');
        if(row!=""){
            Year=row.bsmyear;
            Code=row.bsmcode;
        }
        var DItemType= $('#DItemType').combobox('getValue');// 科目类别
        var DItemCode= $('#DItemBox').val(); 
        var BIDLevel = $('#DItemLevel').combobox('getValue'); 
        var IsLast = $('#IsLastBox').checkbox('getValue'); 
        		if(IsLast == true){
            		IsLast=1;
        		}else{
            		IsLast=0;
        		}
        		
        DetailGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
                MethodName:"ListDetail",
                hospid :    hospid, 
                BIDLevel :  BIDLevel,
                Code   :    Code,
                Year   :    Year,
                BSDCode:    DItemCode,
                BITName :   DItemType, 
                islast :    IsLast  
            })
    }

    // 点击查询按钮 
    $("#DFindBn").click(DFindBtn);

    $("#DSaveBn").click( function(){
		var grid = $('#DetailGrid');
        var indexs=grid.datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                grid.datagrid("endEdit", indexs[i]);
            }
        }
        var rows = grid.datagrid("getChanges");
        var rowIndex="",row="",data="";
        if(rows.length>0){
            $.messager.confirm('确定','确定要保存修改的数据吗？',function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        rowIndex = grid.datagrid('getRowIndex', row);
                        grid.datagrid('endEdit', rowIndex);
                        if (checkBeforeSave(grid,row) == true) {
                            if (data == "") {
                                data = row.rowid + "^" + row.bfplanvalue;
                            } else {
                                data = data + "|" + row.rowid + "^" + row.bfplanvalue;
                            }                           
                        }else {
                            continue;
                        }
                    }
                    saveOrder(data); //保存方法
                    grid.datagrid("reload");
                }
            })
        }
	});
    //保存前检查函数
    function checkBeforeSave(grid,row){ 
        var fields=grid.datagrid('getColumnFields') 
        for (var j = 0; j < fields.length; j++) {
            var field=fields[j];
            var tmobj=grid.datagrid('getColumnOption',field);  
            if (tmobj != null) {
                var reValue="";
                reValue=row[field];
                if(reValue == undefined){
                    reValue = "";
                }
                if (tmobj.allowBlank == false) {
                    var title = tmobj.title;
                    if ((reValue== "")||(reValue == undefined)||(parseInt(reValue) == 0)) {
                        var info =title + "列为必填项，不能为空或零！";
                        $.messager.popover({msg: info,type:'error'});
                        return false;
                    }
                }
            }
        }
        return true;
    }
    //保存方法
    var saveOrder=function(data) {       
        $.m({
            ClassName:'herp.budg.hisui.udata.uBudgSchemAuditWideHos',MethodName:'SaveLots',data:data},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '保存成功！',type:'success'});
                    }else{
                        $.messager.popover({msg: "错误:"+Data,type:'error'});
                    }
                }
        );            
    }
    
    
}