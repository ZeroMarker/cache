
/**
CSP: herp.budg.hisui.budgschemauditwidehos.csp
*/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
    Detail();
}); 

function Init(){
    //年度
    var YBoxObj = $HUI.combobox("#YBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(data){ 
         	$('#DItemLevel').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemLev&hospid="+hospid+"&userid="+userid+"&year="+data.year;
	        $('#DItemLevel').combobox('reload', url);//联动下拉列表重载   
        	
        	MainGridObj.load({
            	ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
            	MethodName:"ListMain",
            	hospid :    hospid, 
            	UserID :    userid,
            	Year   :    data.year
        	})
     	}
    });
    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:100,hidden: true},
                {field:'bsmyear',title:'年度',width:60},
                {field:'bsmcode',title:'方案编号',width:80},
                {field:'bsmname',title:'方案名称',width:200},
                {field:'bsmorderby',title:'编制顺序',width:80},
                {field:'bidname',title:'结果对应预算项',width:120},
                {field:'bmsuupschemdr',title:'前置方案',width:80,
                    formatter:function(value,row,index){
                        return '<span class="grid-td-text">查询</span>';
                    }
                },
                {field:'bsachkstate',title:'编制状态',width:80,
	                formatter:function(value,row,index){
	                    if (value == 1) {
	                        return '<span class="grid-td-text">新建</span>';
	                    } else if(value == 2) {
	                        return '<span class="grid-td-text">提交</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">通过</span>';
	                    }else{
	                        return '<span class="grid-td-text">完成</span>';
	                    }
	                }
	            },
                {field:'bsachkstep',title:'编制步骤',width:80},
                {field:'bcfmchkflowname',title:'审批流',width:100},
                {field:'bsmfile',title:'说明文件',width:80},
                {field:'basriscurstep',title:'是否为当前审批',width:120,
                    formatter:function(value,row,index){
                        if (value == 1) {
                            return '<span>是</span>';
                        } else{
                            return '<span>否</span>';
                        }
                    }
                },
                {field:'schemAuditDR',title:'方案归口表ID',width:100,hidden: true},
                {field:'Chkstate',title:'本人审批状态',width:100,hidden: true,
	                formatter:function(value,row,index){
	                    if (value == 1) {
	                        return '<span class="grid-td-text">等待审批</span>';
	                    } else if(value == 2) {
	                        return '<span class="grid-td-text">同意</span>';
	                    }else if(value == 3) {
	                        return '<span class="grid-td-text">不同意</span>';
	                    }
	                }
	            },
                {field:'bsarstepno',title:'本人审批顺序号',width:100,hidden: true},
                {field:'StepNO',title:'本人审批流顺序号',width:200,align:'right',hidden: true}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL/*,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
            MethodName:"ListMain",
            hospid :    hospid, 
            UserID :    userid,
            Year   :    ""        
        }*/,
        fitColumns: false,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell:function(index, field, value){
            var rows = $('#MainGrid').datagrid('getRows');
            if(field=='bmsuupschemdr'){
                ChildFun(rows[index].rowid)
            }
            if(field=='bsachkstate'){
                schemastatefun(rows[index].schemAuditDR, userid, rows[index].rowid,"","");
            }
            var iscurstep = rows[index].basriscurstep;
            var bsarstepno = rows[index].bsarstepno; 
            var StepNO = rows[index].StepNO;
            var bsachkstep = rows[index].bsachkstep;
            if (bsachkstep == 99) {
                $('#DSaveBn').linkbutton("disable");
                $('#DCheckBn').linkbutton("disable");
            }else if ((StepNO == bsarstepno) && (iscurstep == '1')) {
                $('#DSaveBn').linkbutton("enable");
                $('#DCheckBn').linkbutton("enable");
            }else {
                $('#DSaveBn').linkbutton("disable");
                $('#DCheckBn').linkbutton("disable");
            }
        },
        onClickRow:function(index,row){
        	$("#detailfm").form("clear");
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
                MethodName:"ListDetail",
                hospid :    hospid, 
                BIDLevel :    "",
                Code   :    row.bsmcode,
                Year   :    row.bsmyear,
                BSDCode:   "" ,
                BITName :   ""  
            });     
        },
        toolbar: '#tb'
    });    
    // 查询函数
    var FindBtn= function()
    {
        var Year = $('#YBox').combobox('getValue');  
        MainGridObj.load({
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditWideHos",
            MethodName:"ListMain",
            hospid :    hospid, 
            UserID :    userid,
            Year   :    Year
        })
    }

    // 点击查询按钮 
    $("#FindBn").click(FindBtn);

	$("#DCheckBn").click( function(){
	    
        var selectedRow = $('#MainGrid').datagrid('getSelected');
        if(selectedRow==null){
			$.messager.popover({
						    msg:'请选择方案！',timeout: 3000,type:'info',showType: 'show',
				            style:{
					            "position":"absolute",
					            "z-index":"9999",
					            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
					            top:1
					        }
			});	 
            return;
        }
        var iscurstep = selectedRow.basriscurstep;
        var bsarstepno = selectedRow.bsarstepno; 
        var StepNO = selectedRow.StepNO;
        if ((StepNO == bsarstepno) && (iscurstep == '1')) {
            var rowIndex = $('#MainGrid').datagrid('getRowIndex',selectedRow);
            auditFun(rowIndex);
        }
        
    })
}