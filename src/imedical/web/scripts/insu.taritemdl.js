/**
 * FileName: insu.taritemdl.js
 * Anchor: ZhaoZW
 * Date: 2020-02-24
 * Description: 医保目录管理界面
 */
// 定义常量
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],	//操作员ID
		CTLOC_ROWID: session['LOGON.CTLOCID'],	//科室ID
		WARD_ROWID: session['LOGON.WARDID'],	//病区ID
		HOSP_ROWID: session['LOGON.HOSPID']		//院区ID
	},
	CLASSNAME: 'web.InsuTaritemsDLCtl',			//业务代码逻辑类
	METHODNAME: {
		IMPORT: 'ImportInsuTarItemByExcel',		//医保目录导入方法
		ADUIT: 'AduitInsuTaritem',				//医保目录审核方法
		COMPARE: 'CompareInsuTaritemInfo',  //比较方法
		ADUITALL: 'AduitInsuTaritemAll',  //审全部核医保目录方法
		GETLASTDOWNDATE: 'QueryLastDownTime' //获得最后一次下载的时间
	},
	QUERYNAME: {
		INSU_DICDATA: 'QueryInsuDicDataInfo',	//查询医保字典方法
		INSU_TARITEM: 'QueryInsuTaritemInfo',	//查询医保目录方法
		DATAVERSION: 'QueryDataVersionInfo'		//查询数据批次方法
	}
};
//入口函数
$(function (){
	setPageLayout(); //设置页面布局
	setElementEvent();	//设置页面元素事件	
});
//设置页面布局
function setPageLayout(){
	initDate();//初始化日期
	initDataList(); //初始化数据列表
	initDiffeCateCombo(); //初始化差异标志下拉框
	initAuditFlagCombo(); //初始化审核标志下拉框
	initINTIMsfxmbmCombo(); //初始化医保类型下拉框
	initINTIMDicType1Combo(); //初始化目录类型下拉框(下载/导入)
	initINTIMDicType2Combo(); //初始化目录类型下拉框(查询/审核)
	initDataVersionCombo(); //初始化数据批次下拉框
}
//设置页面元素事件
function setElementEvent(){
	initDownloadBtn(); //初始化目录下载按钮事件
	initImportBtn(); //初始化目录导入按钮事件
	initSearchBtn(); //初始化查询按钮事件
	initAduitBtn(); //初始化审核按钮事件
	initCompareBtn(); //初始化比较按钮事件
	//initAduitALLBtn(); //初始化审核全部医保目录事件
}
//初始化审核按钮事件
function initAduitBtn(){
	$('#aduitBtn').click(function(){
		var rows = $('#DataList').datagrid('getChecked');
		if(rows.length<=0){
			$.messager.popover({msg: '您没有要提交审核的数据！',type:'info',timeout: 1000,showType: 'show'});	
			return;
		}
		$.messager.confirm("确定", "您确定要提交审核吗?", function (r) {
			if (r) {
				var InitIndex=0;	//初始索引
				var ErrMsg="";		//错误信息
				var sucNum=0; 		//成功数
				var errNum=0; 		//失败数
				SubmitReview(rows,InitIndex,ErrMsg,sucNum,errNum); //提交审核
			}
		});
	});
}
//初始化比较按钮事件
function initCompareBtn(){
	$('#compareBtn').click(function(){
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//目录类型
		var DataVersion= $('#DataVersion').combobox('getText');				//数据批次
		$.messager.confirm("确定", "您确定要比较没比较的吗?", function (r) {
			if (r) {
				$m({
					ClassName:PUBLIC_CONSTANT.CLASSNAME,
					MethodName:PUBLIC_CONSTANT.METHODNAME.COMPARE,
					DicType:INTIMDicType,		
					DataVer:DataVersion
					},function(txtData){
						var arr=txtData.split('^');
						$.messager.popover({msg:'比较成功:'+arr[0]+'条，比较失败：'+arr[1]+'条！',type:'success',timeout:2000});
		     			loadInsuTaritemInfo();
					}
				);
			}
		});
	});
}
//初始化审核全部医保目录事件
/*
function initAduitALLBtn(){
	$('#compareAllBtn').click(function(){
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//目录类型
		var DataVersion= $('#DataVersion').combobox('getText');				//数据批次
		var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID; //操作员ID
		var InsuType= $('#INTIMsfxmbm').combobox('getValue');
		$.messager.confirm("确定", "您确定要审核所有的医保目录吗?", function (r) {
			if (r) {				
				$m({
					ClassName:PUBLIC_CONSTANT.CLASSNAME,
					MethodName:PUBLIC_CONSTANT.METHODNAME.ADUITALL,
					DicType:INTIMDicType,		
					DataVer:DataVersion,
					UserDr:UserDr,
					InsuType:InsuType
					},function(txtData){
						var arr=txtData.split('^');
						$.messager.popover({msg:'审核成功:'+arr[0]+'条，审核失败：'+arr[1]+'条！',type:'success',timeout:2000});
		     			loadInsuTaritemInfo();
					}
				);
				
			}
		});
	});
}
*/
//提交审核
function SubmitReview(rows,InitIndex,ErrMsg,sucNum,errNum){
	var row=rows[InitIndex];   	//当前审核记录
	var length=rows.length;
	var index=$('#DataList').datagrid('getRowIndex', row);	//当前审核记录索引
	var ID=row.RowID;   			//当前审核记录ID
	var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID //操作员ID
	$cm({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		MethodName:PUBLIC_CONSTANT.METHODNAME.ADUIT,
		RowId:ID,
		Index:index,
		UserDr:UserDr
	},function(data){
		if(data.Stauts==0){
			//更新行数据
			$('#DataList').datagrid('updateRow',{
				index:data.Index,
				row:data.Data
			});	
			$('#DataList').datagrid('uncheckRow',data.Index); //取消勾选
			$("input[type='checkbox']")[Number(data.Index)+1].disabled = true; //审核成功后，禁用复选框
			sucNum=sucNum+1;
		}else{
			var ErrMsg=ErrMsg+";"+data.Info;
			errNum=errNum+1;
		}
		var NextIndex=InitIndex+1;  //下一个下索引
		if(NextIndex<length){
			SubmitReview(rows,NextIndex,ErrMsg,sucNum,errNum)	
		}else{
			$.messager.popover({msg:'审核成功:'+sucNum+'条，审核失败：'+errNum+'条！',type:'success',timeout:2000});	
		}
	});	
}
//初始化查询按钮事件
function initSearchBtn(){
	$('#searchBtn').click(function(){
		loadInsuTaritemInfo();
	});
}
//初始化目录下载按钮事件
function initDownloadBtn(){
	/// 医保目录下载
	$('#downloadBtn').click(function(){
		var InsuType= $('#INTIMsfxmbm').combobox('getValue');
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');
		$m({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		MethodName:PUBLIC_CONSTANT.METHODNAME.GETLASTDOWNDATE,
		InsuType:InsuType,
		DicType:INTIMDicType
		},function(data){
			var dateNow=$('#StDate').combobox('getValue');
			var LastDownDate=data.split(" ")[0];
			var diff=dateDiff(dateNow,LastDownDate);
			if(parseInt(diff)<7)
				$.messager.confirm("确定", "您上次下载距离这次只有"+diff+"天，您确定要下载医保目录吗?", function (r) {
					if (r) {
						downLoadTarItem();
					}
				});
			else
				downLoadTarItem();
		});
	});
}
/// 医保目录下载
function downLoadTarItem(){
	var InsuType=$('#INTIMsfxmbm').combobox('getValue');
	var DicType=$('#INTIMDicType1').combobox('getValue');
	var StDate=$('#StDate').combobox('getValue');
	var UserId=session['LOGON.USERID'];
	var ExpStr=DicType+"^"
	var outStr=InsuBasTarItmDL(InsuType,StDate,UserId,ExpStr);
	if (outStr!="0"){
		alert("医保目录下载保存失败!outStr="+outStr);
	}
	else{
		//下载保存成功后刷新页面
		PageDataRefresh();
	}
}
//初始化目录导入按钮事件
function initImportBtn(){
	///功能说明：导入字典信息
	$('#importBtn').click(function(){
		var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;		//操作员ID
		var GlobalDataFlg="0";                          	//是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName=PUBLIC_CONSTANT.CLASSNAME;    		//导入处理类名
		var MethodName=PUBLIC_CONSTANT.METHODNAME.IMPORT;   //导入处理方法名
		var ExtStrPam="";                   				//备用参数()
		//ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam, PageDataRefresh);  //导入 增加了回调方法
	});	
}

/// 功能说明：下载完成后或者导入完成后刷新页面显示最新的数据
///           1.数据批次下拉框需要更新 2.查询数据列表需要显示最新数据
function PageDataRefresh(){
	//1.数据批次下拉框需要更新
	$('#DataVersion').combobox({
		onLoadSuccess: function(){
			$('#DataVersion').combobox('setValue','1'); //初始化下拉框的初始值
			loadInsuTaritemInfo(); //在加载数据批次成功时加载数据列表的数据
		}
	});
	$('#DataVersion').combobox('reload');  //查询数据列表需要显示最新数据
	//initDataVersionCombo();
	//2.查询数据列表需要显示最新数据
	//loadInsuTaritemInfo();
}

//初始化目录类型下拉框(下载/导入)
function initINTIMDicType1Combo(){
	var id='INTIMDicType1';	//下拉框id(下载/导入)
	var DicType="TariType";  //目录类型字典类型编码为:TariType
	initCombobox(id,DicType);
}
//初始化目录类型下拉框(查询/审核)
function initINTIMDicType2Combo(){
	var id='INTIMDicType2';	//下拉框id(查询/审核)
	var DicType="TariType";  //目录类型字典类型编码为:TariType
	initCombobox(id,DicType);
}
//初始化医保类型下拉框
function initINTIMsfxmbmCombo(){
	var id='INTIMsfxmbm';	//下拉框id
	var DicType="DLLType";  //医保类型字典类型编码为:DLLType
	initCombobox(id,DicType);
}
//初始化差异标志下拉框
function initDiffeCateCombo(){
	$HUI.combobox("#DifferenceCate",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'ALL',desc:'全部数据',selected:true},
			{code:'1',desc:'新增'},
			{code:'2',desc:'更新'},
			{code:'3',desc:'失效'},
			{code:'0',desc:'无差异'},
			{code:'99',desc:'未比较'}
		],
		onSelect: function(){
        	loadDataVersionInfo();	//重新加载数据批次
   		}
	});	
}
//初始化审核标志下拉框
function initAuditFlagCombo(){
	$HUI.combobox("#AuditImportFlag",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'ALL',desc:'全部数据',selected:true},
			{code:'0',desc:'未审核'},
			{code:'1',desc:'已审核导入'},
			{code:'2',desc:'审核拒绝'}
		],
		onSelect: function(){
        	loadDataVersionInfo();	//重新加载数据批次
   		}
	});	
}
//初始化数据批次下拉框
function initDataVersionCombo(){
	//var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			
	var INTIMDicType="FYB"	//目录类型
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//差异标志
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//审核标志
	$HUI.combobox('#DataVersion',{
		valueField:'VerCode', 
		textField:'VerDesc',
		editable:true,
		url:$URL,
		mode:'remote',
    	onBeforeLoad:function(param){
	   		param.ClassName=PUBLIC_CONSTANT.CLASSNAME
	    	param.QueryName=PUBLIC_CONSTANT.QUERYNAME.DATAVERSION
	    	param.ResultSetType="array"
	    	param.DicType=INTIMDicType
	    	param.DiffCate=DifferenceCate
	    	param.AuditFlag=AuditImportFlag
	    },
	    onLoadSuccess:function(){
			$('#DataVersion').combobox('setValue','1');	
		}
	});	
}
//初始化数据列表
var count=0; //计数器
function initDataList(){
	$HUI.datagrid('#DataList',{
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
    	columns:[[   
    		{field:'checkbox',checkbox:true},
    		{field:'RowID',title:'RowID',hidden:true},
        	{field:'DataVersion',title:'数据批次',width:126,align:'center'},    
        	{field:'INTIMxmbm',title:'项目编码',width:126,align:'center'},    
        	{field:'INTIMxmmc',title:'项目名称',width:150,align:'center'},
        	{field:'AuditImportFlag',title:'审核标记',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="0"){
						return "未审核";
					}
					if (value=="1"){
						return "审核导入";
					}
					if (value=="2"){
						return "审核拒绝";
					}
				},
				styler: function(value,row,index){
					if(value == '1'){
						return 'background-color:#ffee00;color:red;';
					}
				}
        	}, 
        	{field:'ActiveFlg',title:'有效标志',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="1"){
						return "有效";
					}
					if (value=="0"){
						return "无效";
					}
				}
        	},    
        	{field:'DifferenceCate',title:'差异分类',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="1"){
						return "新增";
					}
					if (value=="2"){
						return "更新";
					}
					if (value=="3"){
						return "有效标识变化";
					}
					if (value=="0"){
						return "无差异";
					}
					if (value=="99"){
						return "未比较";
					}
				}
        	},    
        	{field:'DifferenceCom',title:'差异内容',width:200,align:'center',showTip:true
        		/*
        		formatter:function(value,rowData){
	        		return "<span title='" + value + "'>" + value + "</span>";
	        		
	        		alert(1)
	        		var abValue = value;
	        		var content = '<a  href="#" title="'+abValue+'" class="hisui-tooltip">' + rowData.INTIMxmmc + '</a>';
        				return content;/*
	        		///abValue=getInsuTarItemDlDesc(value)
        			if (value.length>=22) {
            			//abValue = value.substring(0,13) + "..."	
        				var content = '<a  href="#" title="'+abValue+'" class="hisui-tooltip">' + rowData.INTIMxmmc + '</a>';
        				return content;
        			}else{
        				return value;
        			}
	        	}
	        	*/
        	},
        	{field:'INTIMActiveDate',title:'生效日期',width:100,align:'center'},
        	{field:'INTIMExpiryDate',title:'失效日期',width:120,align:'center'},
        	{field:'INTIMsfdlbm',title:'收费大类',width:100,align:'center'},
        	{field:'INTIMtjdm',title:'统计项目',width:100,align:'center'}, 
        	{field:'INTIMxmlb',title:'项目类别',width:100,align:'center'},
        	{field:'INTIMjx',title:'剂型',width:100,align:'center'}, 
        	{field:'INTIMpzwh',title:'批准文号',width:100,align:'center'},
        	{field:'INTIMbzjg',title:'标准价格',width:100,align:'center'},
        	{field:'INTIMsjjg',title:'实际价格',width:100,align:'center'},
        	{field:'INTIMzgxj',title:'最高限价',width:100,align:'center'},
        	{field:'INTIMzfbl1',title:'自付比例1',width:100,align:'center'},
        	{field:'INTIMzfbl2',title:'自付比例2',width:100,align:'center'},
        	{field:'INTIMzfbl3',title:'自付比例3',width:100,align:'center'}, 
        	{field:'INTIMtxbz',title:'特殊项标志',width:100,align:'center'},
        	{field:'INTIMflzb1',title:'分类指标1',width:100,align:'center'},
        	{field:'INTIMflzb2',title:'分类指标2',width:100,align:'center'},
        	{field:'INTIMflzb3',title:'分类指标3',width:100,align:'center'},
        	{field:'INTIMflzb4',title:'分类指标4',width:100,align:'center'},
        	{field:'INTIMflzb5',title:'分类指标5',width:100,align:'center'},
        	{field:'INTIMflzb6',title:'分类指标6',width:100,align:'center'},
        	{field:'INTIMflzb7',title:'分类指标7',width:100,align:'center'},
        	{field:'INTIMspmc',title:'商品名称',width:100,align:'center'},
        	{field:'INTIMspmcrj',title:'商品名称热键',width:100,align:'center'},
        	{field:'INTIMljzfbz',title:'累计增负标志',width:100,align:'center'}, 
        	{field:'INTIMyyjzjbz',title:'医院增加标志',width:100,align:'center'},
        	{field:'INTIMyysmbm',title:'医院三目编码',width:100,align:'center'},
        	{field:'INTIMfplb',title:'发票类别',width:100,align:'center'},
        	{field:'INTIMDicType',title:'目录类型',width:100,align:'center'},
        	{field:'INTIMUserDR',title:'添加人',width:100,align:'center'},
        	{field:'INTIMDate',title:'添加日期',width:100,align:'center'},
        	{field:'INTIMTime',title:'添加时间',width:100,align:'center'},
        	{field:'INTIMADDIP',title:'修改机器',width:100,align:'center'},
        	{field:'INTIMUnique',title:'医保中心唯一码',width:110,align:'center'}
    	]],
        //加载完毕后触发获取所有的checkbox遍历判断哪些单选框不可选取
        onLoadSuccess:function(data){
            $('#DataList').datagrid('clearSelections');
            if (data.rows.length > 0) {
                for (var i = 0; i < data.rows.length; i++) {
                    //未比较且未审核的数据不能选择，已审核的数据也不能选择
                    if (("99"==data.rows[i].DifferenceCate && data.rows[i].AuditImportFlag!="1") || ((data.rows[i].AuditImportFlag == "1"))||("0"==data.rows[i].DifferenceCate)) {
                        $("input[type='checkbox']")[i + 1].disabled = true;
                    }
                }
            }
        },
        //当用户点击一行时触发，参数包括： rowIndex：被点击行的索引，从 0 开始 ,rowData：被点击行对应的记录
        onClickRow: function(rowIndex, rowData){
            //加载完毕后获取所有的checkbox遍历,单击单选行不可用  
            $("input[type='checkbox']").each(function(index, row){
                //如果当前的复选框不可选，则不让其选中
                if (row.disabled == true) {
                    $("#DataList").datagrid('uncheckRow', index - 1);
                }
            });
        },
        //当用户双击一行时触发，参数包括： rowIndex：被点击行的索引，从 0 开始 ,rowData：被点击行对应的记录
        onDblClickRow : function(rowIndex, rowData) {  
            //加载完毕后获取所有的checkbox遍历双击单选行不可用  
            $("input[type='checkbox']").each(function(index, row){
                //如果当前的复选框不可选，则不让其选中
                if (row.disabled == true) {
                    $("#DataList").datagrid('uncheckRow', index - 1);
                }
            });
        },
        //当用户勾选全部行时触发
        onCheckAll:function(rows) {  
            var num=0;
            $("input[type='checkbox']").each(function(index, row) {
                if(row.disabled== true){
                    $("#DataList").datagrid('uncheckRow', index - 1); 
                    num++;
                }
            });
            if(num>0){
              $("input[type='checkbox']").each(function(index, row) { 
                      if(count%2==0){
                          if (row.disabled== true){
	                          $("#DataList").datagrid('uncheckRow', index - 1);
                          }
                      }else{
	                  	$("#DataList").datagrid('uncheckRow', index - 1);
                      }
                  }); 
              count++;  
            } 
        }
	});	
}
//加载医保目录数据
function loadInsuTaritemInfo(){
	var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//目录类型
	var DataVersion= $('#DataVersion').combobox('getText');				//数据批次
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//差异标志
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//审核标志
	$('#DataList').datagrid('load',{
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		QueryName:PUBLIC_CONSTANT.QUERYNAME.INSU_TARITEM,
		DicType:INTIMDicType,		
		DataVer:DataVersion,		
		DiffCate:DifferenceCate,	
		AuditFlag:AuditImportFlag	
	});
}
// 查询医保字典表下拉框(id:下拉框id,DicType:字典类型编码)
function initCombobox(id,DicType){
	$HUI.combobox('#'+id,{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	onBeforeLoad:function(param){
	   		param.ClassName=PUBLIC_CONSTANT.CLASSNAME
	    	param.QueryName=PUBLIC_CONSTANT.QUERYNAME.INSU_DICDATA
	   		param.ResultSetType="array"
	 		param.DicType=DicType       
	    },
	    onLoadSuccess:function(){
		    $('#'+id).combobox('setValue','FYB');	
		},
		onSelect: function(){
			if(id=="INTIMDicType2"){
        		loadDataVersionInfo();	//重新加载数据批次
			}
   		}
	});	
}
//重新加载数据批次
function loadDataVersionInfo(){
	var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//目录类型
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//差异标志
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//审核标志
	$cm({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		QueryName:PUBLIC_CONSTANT.QUERYNAME.DATAVERSION,
		ResultSetType:"array",
		DicType:INTIMDicType,
		DiffCate:DifferenceCate,
		AuditFlag:AuditImportFlag
	},function(Data){
		if(Data.length > 0){
			$('#DataVersion').combobox('loadData', Data);
		}
	});
}
//初始化日期
function initDate(){
	//获取当前日期
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#StDate').datebox('setValue', nowDate);
	//设置结束日期值
	$('#EdDate').datebox('setValue', nowDate);
}
//计算两个日期的天数差
function dateDiff(firstDate,secondDate){
	var firstDate = new Date(firstDate);
	var secondDate = new Date(secondDate);
	var diff = Math.abs(firstDate.getTime() - secondDate.getTime())
	var result = parseInt(diff / (1000 * 60 * 60 * 24));
	return result
}