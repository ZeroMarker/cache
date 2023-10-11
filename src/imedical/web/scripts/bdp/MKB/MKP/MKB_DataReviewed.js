/*
* @Author: 基础数据平台-石萧伟
* @Date:   2019-05-28
* @描述:上报
*/
var init=function()
{
    var SelMRCICDRowid=""; //诊断查找下拉框的诊断id
    var findCondition="";  //诊断描述
    var CacheDiagPropertyData={}; //快速检索中属性列表获取
    var CacheDiagPropertyDataNote={}; //快速检索中属性列表备注获取
    var PreSearchText="";
    var base=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetIdByFlag","Diagnose");
	var indexTemplate=undefined;//已选属性列表选中的模板id标识
	var SelPropertyArr=new Array();
	var SelPropertyData=""; //已选属性列表串

	//var icdflagforsel = 2//选中icd用
	var pageType = "";//判断上报到哪个界面
	//当前医院icd库id
	var icdtermbase = tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","getICDTermId")

	//诊断名回车事件
	$('#textDiaDr').keyup(function(event){
		if(event.keyCode == 13) {
			refreshSameGrid();
			$('#result_dia_id').val('');
		}else{
			$('#result_dia_id').val('');
		}
	}); 	
	
    /******************************ICD下拉列表开始**************************************************************/	

	//修改icd编码
	var ICDColumns=[[ 
		{field:'MKBTRowid',title:'RowId',width:250,hidden:true}, 
		{field:'MKBDesc',title:'ICD描述',width:290},
		{field:'MKBNumber',title:'ICD10编码',width:290}
		
	]];		
	var icdgrid = $HUI.datagrid("#ICDGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetICDTermList",
			base:icdtermbase
		},
		width:703,
		height:460,
		//toolbar:'#ICDbar',
		columns: ICDColumns,  //列信息
		showHeader:true,
		pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:10,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:true,
		checkOnSelect:false,
		selectOnCheck:false,
		remoteSort:false,
		idField:'MKBTRowid',
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onDblClickRow:function(rowIndex, field, value){
		},
		onClickRow:function(rowIndex,rowData){
			var text = (rowData.MKBNumber).slice(0,3);//只要数点前边的数字
			$('#TextInterDesc').val('');
			$('#TextInterCode').val(text);
			$('#interGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
				MethodName:"GetMyList",
				base : icdBase,
				desc : text
			});	
		},
		onLoadSuccess:function(data){
			//setTimeout(function(){
				var icdid = $('#result_icd_id').val();//$('#leftgrid').datagrid('getSelected').MKBSDMDr;
				//alert(icdid)
				/*if(icdid != "" && icdflagforsel == 1){
					var index=$('#ICDGrid').datagrid('getRowIndex',icdid);  
					$('#ICDGrid').datagrid('selectRow',index);	
				}*/  
			//},4000) 			
		}
	})	
	$('#btnicdsearch').click(function(e){
		//icdflagforsel = 2
		var desc = $('#TexticdDesc').val()
		var code = $('#TexticdCode').val()
		$('#ICDGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetICDTermList",
			desc:desc,
			number:code,
			base:icdtermbase
		});	
		$('#ICDGrid').datagrid('unselectAll')		
	})
	$('#btnicdrefresh').click(function(e){
		//icdflagforsel = 2
		$('#TexticdDesc').val('')
		$('#TexticdCode').val('')
		$('#ICDGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBStructuredData",
			QueryName:"GetICDTermList",
			base:icdtermbase
		});	
		$('#ICDGrid').datagrid('unselectAll')	
	})

	//国际码grid
	var interColumns=[[ 	
		{field:'MKBTRowId',title:'RowId',width:250,hidden:true}, 
		{field:'MKBTDesc',title:'国际码',width:100},
		{field:'MKBTPDDesc',title:'中文释义',width:200,
			formatter: function(value, row, index) {
			var content = '<span href="#" title="' + value + '" class="myltooltip">' + value + '</span>';
			return content;
		}},
		{field:'MKBTPDDescE',title:'英文释义',width:200,
		formatter: function(value, row, index) {
			var content = '<span href="#" title="' + value + '" class="myltooltip">' + value + '</span>';
			return content;
		}}
	]];
	$('#interGrid').datagrid({ 
		//headerCls:'panel-header-gray',
		width:743,
		height:443, 
		pagination: true, 
		pageSize:PageSizeMain,
		showHeader:true,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		displayMsg:"",
		//bodyCls:'panel-header-gray', 
		//toolbar:'#interbar',
		fitColumns: true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
			MethodName:"GetMyList",
			base : icdBase
		},
		singleSelect:true,
		idField:'MKBTRowId',	
		columns:interColumns,
		onDblClickRow: function (rowIndex,rowData) {
		},
		onLoadSuccess:function(data){
			$('.myltooltip').tooltip({
				trackMouse:true,
				onShow:function(e){
					$(this).tooltip('tip').css({
						width:250 ,top:e.pageY+20,left:e.pageX-(250/2)
					});
				}

			});			
		}
	});	
	//查询国际码
	$('#btninterSave').click(function(e){
		var desc = $('#TextInterCode').val();
		var descch = $('#TextInterDesc').val();
		$('#interGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
			MethodName:"GetMyList",
			base : icdBase,
			desc : desc,
			descch : descch
		});
	});
	//清屏国际码
	$('#btninterClear').click(function(e){
		$('#TextInterCode').val('');
		$('#TextInterDesc').val('');
		$('#interGrid').datagrid('load',  { 
			ClassName:"web.DHCBL.MKB.MKBHISICDContrast",
			MethodName:"GetMyList",
			base :icdBase
		});		
	})
	$('#commiticdbtn').click(function(e){
		var data = $('#ICDGrid').datagrid('getData')
		if(data.rows.length > 0){
			var record = $('#ICDGrid').datagrid('getSelected')
			if(record){
				var icd = record.MKBDesc;
				var id = record.MKBTRowid;
				var code = record.MKBNumber;
				$('#result_icd_id').val(id);
				$('#textICDCode2').val(code)
				$('#textICDDr').val(icd)

			}else{
				$.messager.alert('错误提示','请先选择一条数据!',"error");
				return;
			}
		}else{
			var icd = $('#TexticdDesc').val();
			$('#textICDDr').val(icd);
			$('#textICDCode2').val('')
			$('#result_icd_id').val('');
		}

		setTimeout(function(){
			refreshSameGrid();
		},100)
		$('#icdDiv').dialog('close')
		$('#TexticdDesc').val('');
		
	})
	$('#icdcancelBtn').click(function(e){
		$('#icdDiv').dialog('close');
	})
	/*$('#textICDDr,#textICDCode2').click(function(e){
		//icdflagforsel = 1
		if(pageType != "ICD"){
			var id = $(this).attr('id')
			var desc = ""
			var code = ""
			if(id == "textICDDr"){
				$('#TexticdDesc').val($('#textICDDr').val())
				$('#TexticdCode').val('')
				desc = $('#textICDDr').val()
			}else if(id == "textICDCode2"){
				$('#TexticdDesc').val('')
				$('#TexticdCode').val($('#textICDCode2').val().slice(0,6))
				code = $('#textICDCode2').val().slice(0,6)
			}
			$('#ICDGrid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBStructuredData",
				QueryName:"GetICDTermList",
				desc:desc,
				number:code,
				base:icdtermbase
			});	
			$('#icdDiv').show();
			var icdDiv = $HUI.dialog("#icdDiv",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'ICD',
				modal:true
			})
	
		}
	})*/
    ICDWin=function(flag)
    {
        if(pageType != "ICD"){
            var id = $(this).attr('id')
            var desc = ""
            var code = ""
            if(flag == 1){
                $('#TexticdDesc').val($('#textICDDr').val())
                $('#TexticdCode').val('')
                desc = $('#textICDDr').val()
            }else if(flag == 2){
                $('#TexticdDesc').val('')
                $('#TexticdCode').val($('#textICDCode2').val().slice(0,6))
                code = $('#textICDCode2').val().slice(0,6)
            }
            $('#ICDGrid').datagrid('load',  { 
                ClassName:"web.DHCBL.MKB.MKBStructuredData",
                QueryName:"GetICDTermList",
                desc:desc,
                number:code,
                base:parent.icdtermbase
            }); 
            $('#icdDiv').show();
            var icdDiv = $HUI.dialog("#icdDiv",{
                iconCls:'icon-w-edit',
                resizable:true,
                width:$('#layout').width()*9.5/10,
                height:$('#layout').height()*9.5/10,
                title:'ICD',
                modal:true
            })
    
        }
    }

    /******************************ICD下拉列表结束**************************************************************/	
    /******************************诊断下拉列表结束**************************************************************/	
    /*$('#textResult2').click(function(e){
        $('#mypropertylist').show();
		var icdDiv = $HUI.dialog("#mypropertylist",{
            iconCls:'icon-w-edit',
            resizable:true,
            title:'结构化诊断',
            modal:true
        });	

    //加载结构化诊断模块
    var termid= $('#result_term_id').val()
    var termDesc = ""
    var desc2 = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","findTermDescById",termid); 
    if(desc2 != ""){
        termDesc = desc2
    }
    var ccc = $("#combogrid")
    if(termid!=""){
        $("#div-img").hide();
    }
    CreatPropertyDom("",termid,"","");   
    LoadDiagnosData(termDesc,ccc);//加载诊断下拉框
    $('#combogrid').combogrid('setValue',termid);                    
    setTimeout(function(){
    //诊断列表有选中时，才允许弹出属性列表
        findCondition = "" ; 
    },50)    
        SelMRCICDRowid = termid
    })*/

    propertyListWin = function()
    {
        $('#mypropertylist').show();
        var icdDiv = $HUI.dialog("#mypropertylist",{
            iconCls:'icon-w-edit',
            resizable:true,
            width:$('#layout').width()*9.5/10,
            height:$('#layout').height()*9.5/10,
            title:'结构化诊断',
            modal:true
        }); 

        //加载结构化诊断模块
        var termid= $('#result_term_id').val()
        var termDesc = ""
        var desc2 = tkMakeServerCall("web.DHCBL.MKB.MKBICDContrast","findTermDescById",termid); 
        if(desc2 != ""){
            termDesc = desc2
        }
        var ccc = $("#combogrid")
        if(termid!=""){
            $("#div-img").hide();
        }
        CreatPropertyDom("",termid,"","");   
        LoadDiagnosData(termDesc,ccc);//加载诊断下拉框
        $('#combogrid').combogrid('setValue',termid);                    
        setTimeout(function(){
        //诊断列表有选中时，才允许弹出属性列表
            findCondition = "" ; 
        },50)    
        SelMRCICDRowid = termid
    }


    //下拉列表（诊断）
    $('#combogrid').combogrid({
        //url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTermListForDoc",
        panelWidth:500,
        panelHeight:308,
        delay: 1000,    
        mode: 'remote',  
        showHeader:false,
        fitColumns: true,   
        striped: true,   
        editable:true,   
        rownumbers:false,//序号   
        collapsible:false,//是否可折叠的   
        fit: true,//自动大小   
        pagination : true,//是否分页   
        pageSize: 8,//每页显示的记录条数，默认为10   
        pageList: [8,15,30,100,300],//可以设置每页记录条数的列表   
        method:'get', 
        idField: 'MKBTRowId',    
        textField: 'MKBTDesc',    
        columns: [[    
            {field:'MKBTDesc',title:'诊断名称',width:200,sortable:true,
                formatter:function(value,rec){ 
                    var tooltipText=value.replace(/\ +/g,"")
                    var len=value.split(findCondition).length;
                    var value1="";
                    for (var i=0;i<len;i++){
                        var otherStr=value.split(findCondition)[i];
                        if (i==0){
                            if (otherStr!=""){
                                value1=otherStr
                            }
                        }else{
                            value1=value1+"<font color='red'>"+findCondition+"</font>"+otherStr;
                        }
                    }
                    
                      //鼠标悬浮显示备注
                        var MKBTNote=rec.MKBTNote
                        MKBTNote=MKBTNote.replace(/\ /g, "")
                        MKBTNote=MKBTNote.replace(/\>/g, "大于")
                        if (MKBTNote!=""){
                            value="<span class='hisui-tooltip' title="+MKBTNote+">"+value1+"</span>" 
                        }else{
                            value="<span class='hisui-tooltip' title="+tooltipText+">"+value1+"</span>" 
                        }
                        return value;     
                    } 
                   
            },
            {field:'MKBTCode',title:'诊断代码',width:120,sortable:true,hidden:true},
            {field:'MKBTRowId',title:'MKBTRowId',width:120,sortable:true,hidden:true}
        ]],
        keyHandler:{
            up: function () {
                //取得选中行
                var selected = $(this).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                       $(this).combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $(this).combogrid('grid').datagrid('getRows');
                    $(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
				}
				$("#div-img").show();
             },
             down: function () {
              //取得选中行
                var selected = $(this).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
                        $(this).combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $(this).combogrid('grid').datagrid('selectRow', 0);
				}
				$("#div-img").show();
            },
            left: function () {
                return false;
            },
            right: function () {
                return false;
            },            
            enter: function () { 
                //文本框的内容为选中行的的字段内容
                var selected = $(this).combogrid('grid').datagrid('getSelected');  
                if (selected) { 
                  //DHCDocUseCount(selected.MKBTRowId, selected.MKBTDesc,"User.SDSStructDiagnos")
                  $(this).combogrid("options").value=selected.MKBTRowId;
                  SelMRCICDRowid=selected.MKBTRowId; //诊断id
                  $("#SelMKBRowId").val(SelMRCICDRowid);
                  $("#Form_DiagDesc").val(selected.MKBTDesc)
                  $("#DiagForm").empty();
                  //AddDiagnos();
				}
				$("#div-img").hide();
            },
            query:function(q){
                $(this).combogrid("setValue",q);
                var object=new Object();
                object=$(this)
                if (this.AutoSearchTimeOut) {
                    window.clearTimeout(this.AutoSearchTimeOut)
                    this.AutoSearchTimeOut=window.setTimeout(LoadDiagnosData(q,object),1000)
                }else{
                    this.AutoSearchTimeOut=window.setTimeout(LoadDiagnosData(q,object),1000)
                }
                   
                $(this).combogrid('textbox').bind('click',function(){ //2018-11-02 重新点击时 默认之前输入的值为选中状态，方便删除
                 })
                 
                findCondition=q;
                var reg= /^[A-Za-z]+$/;
                if (reg.test(findCondition)) {
                    findCondition=findCondition.toUpperCase()
				}
				$("#div-img").show();
            }
        },
        onClickRow:function (rowIndex, rowData){
            var selected = cbg.combogrid('grid').datagrid('getSelected');             
            if (selected) {
                //石萧伟改 
                setTimeout(function(){
                    findCondition = selected.MKBTDesc
                },50)                 
                //DHCDocUseCount(selected.MKBTRowId, selected.MKBTDesc,"User.SDSStructDiagnos")
                cbg.combogrid("options").value=selected.MKBTRowId;

                SelMRCICDRowid=selected.MKBTRowId
                $("#SelMKBRowId").val(SelMRCICDRowid);
                $("#Form_DiagDesc").val(selected.MKBTDesc)
                $("#DiagForm").empty();
				//AddDiagnos();
				$("#div-img").hide();
            }
        },
        onLoadSuccess: function(){
        },
        onChange:function(newValue, oldValue){
            $("#Form_DiagDesc").val("")
            $("#DiagForm").empty();
            //RemoveSmartTip();
            if (newValue=="") {
                SelMRCICDRowid="";
			}
        },
        onShowPanel:function(){
            cbg = $(this);
            if (findCondition==""){LoadDiagnosData("",cbg)}
                //$('#Form_DiagPropertySearch').combogrid('hidePanel');//快速检索框下拉隐藏//20180905
        },
        onHidePanel:function(){
            setTimeout(function(){
				//诊断列表有选中时，才允许弹出属性列表
				var termidforjust = $('#combogrid').combogrid('getValue')
				var IdExsit=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","justIdExist",termidforjust);
                if(SelMRCICDRowid!="" && $('#combogrid').combogrid('getText')!="" && IdExsit !=""){
					$("#div-img").hide();
                    //indexTemplate=undefined;
                    //var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+editIndex+']');
                    CreatPropertyDom("",SelMRCICDRowid,"","");
                }else{
					$("#div-img").show();
				}
            },50)
        }        
    })
    //加载combogrid数据
    function LoadDiagnosData(q,obj)
    {
        var desc=q;
        var opts = obj.combogrid("grid").datagrid("options");
        var queryParams = new Object(); 
        //queryParams.ClassName="web.DHCBL.MKB.MKBTermProDetail"; 
        //queryParams.QueryName="GetTermListForDoc";
        queryParams.rowid ="";
        queryParams.base =base;
        queryParams.desc =desc;
        //opts.url = $URL  
        //opts.queryParams = queryParams;
        opts.url ="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTermListForDoc"
        opts.queryParams = queryParams;
        //reload 等同于'load'方法，但是它将保持在当前页。
        obj.combogrid("grid").datagrid("load");
    }
    SearchDataFromStrData = function(){
        //GetSelectedPropertyStr();
        var propertyValue = GetPropertyValue("1");
		var MKBSDTermDR = $("#combogrid").combogrid('getValue')
		if (MKBSDTermDR==""||MKBSDTermDR==undefined){
			$.messager.alert('错误提示','诊断不能为空!',"error");
			return;
		}
        var MKBSDStructResultID=propertyValue.split("#")[1];
        var MKBSDSupplement=propertyValue.split("#")[2];
        var resultRequired=propertyValue.split("#")[3]; //必填项未维护结果集 
        var resultDesc = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetChiForNewSeqStrucIDs",MKBSDStructResultID,MKBSDTermDR) 
        if(MKBSDSupplement!=""){
            var SupplementDesc="("+MKBSDSupplement+")"
            resultDesc = resultDesc.split("]")[0]+SupplementDesc+"]"
        }
        $('#textResult2').val(resultDesc)
        var ccc= $('#combogrid')

        $('#result_Ids').val(MKBSDStructResultID)
        $('#result_term_id').val(MKBSDTermDR)
        $('#result_supplement').val(MKBSDSupplement)

        LoadDiagnosData("",ccc);
        SelPropertyData=""
        $('#combogrid').combogrid('setValue',''); 
        $("#div-img").show();       
		$('#mypropertylist').dialog('close');
		setTimeout(function(){
			refreshSameGrid();
		},100) 
		
    }
    //提交
    $('#commitbtn').click(function(e){
        SearchDataFromStrData();
    })
    //取消，关闭结构化诊断
    $('#updataResultBtn').click(function(e){
        $('#mypropertylist').dialog('close');
    })
    /******************************诊断下拉列表结束**************************************************************/	

    /******************************属性列表功能开始**************************************************************/
    //创建可编辑属性列表控件
    function CreatPropertyDom(target,SelMRCICDRowid,Rowid,indexTemplate){
		$('#Form_DiagPropertySearchGrid').datagrid('loadData',{total:0,rows:[]})
		$('#Form_DiagPropertySelectedGrid').datagrid('loadData',{total:0,rows:[]})

		$("#DiagForm").empty();
		//var target=$(jq1).find('td[field='+jq2+']')
		setTimeout(function(){
			//$('#Form_DiagPropertySearch').combogrid('showPanel');//快速检索框下拉弹出
			LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
		},50)
    }
    
	//重载属性列表按钮
	$("#btnReloadPro").click(function (e) { 
		$("#DiagForm").empty();
		SelPropertyData="";
		/*var record=$("#leftgrid").datagrid("getSelected")
		if(record){
			var Rowid=record.Rowid
		}else{*/
			var Rowid=""
		//}
		indexTemplate=undefined;
		LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
		CacheDiagPropertyData={};
		CacheDiagPropertyDataNote={};	
	 })
	/*****************左侧属性快速检索列表开始*******************************************/
	 var ifLoadPropertySearchGrid;
		$HUI.datagrid("#Form_DiagPropertySearchGrid",{
			columns: [[    
				{field:'text',title:'属性名称',width:200,sortable:true,
				formatter:function(value,rec){ 
				   	  //鼠标悬浮显示备注
						if (rec.note!=undefined){
							value="<span class='hisui-tooltip' title='"+rec.note+"'>"+value+"</span>" 
						}
						return value;
	                } 
		         },
		        {field:'note',title:'属性备注',width:200,sortable:true,hidden:true},
				{field:'id',title:'属性id',width:200,sortable:true,hidden:true}
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:100,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			onLoadSuccess:function(){
				var panel = $(this).datagrid('getPanel');   
		        var tr = panel.find('div.datagrid-body tr');   
		        tr.each(function(){   
		          	$(this).css({"height": "20px"})
		        });  
				if (ifLoadPropertySearchGrid==true){
					DiagPropertySearch(PreSearchText,indexTemplate);
					var listArr=new Array();
					var proFrequencyStr=""
					for(i=0;i<$('#Form_DiagPropertySearchGrid').datagrid('getData').total;i++){
						var id = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].id;
						var text = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].text;
						var note = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].note;
						listArr.push({"id":id,"text":text,"note":note});
						proFrequencyStr=proFrequencyStr+"$"+id.split("#")[0]+"#"+id.split("#")[1]
					}
					proFrequencyStr=proFrequencyStr+"$"
					//属性快速检索列表数据再次取前台数组的数据
					for ( var oe in CacheDiagPropertyData) {
						if (proFrequencyStr.indexOf("$"+oe+"$")<0){
							listArr.push({"id":oe,"text":CacheDiagPropertyData[oe],"note":CacheDiagPropertyDataNote[oe]});
						}
					}
					ifLoadPropertySearchGrid=false
					$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
					$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');
				}
			},
			onClickRow:function(rowIndex,rowData){
				var selected = $('#Form_DiagPropertySearchGrid').datagrid('getSelected');  
				if (selected) { 
					var id=selected.id; 
					var trids=id.split("#")[0]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var propertyid=id.split("#")[1];
					var childId=trids.split("_")[1];
					var showType=trids.split("_")[2];
					var treeNode=trids.split("_")[4];
					var isTOrP=trids.split("_")[5];
					var tds=$("#"+trids+"").children();
					for (var j=1;j<tds.length;j++){
						//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
						var detailId=""
						var details=$("#"+trids+" td").children();
						for (var k=1;k<details.length;k++){
							if (k==1){
								detailId=details[k].id
							}
						}
						if (showType=="T"){		  
							if ((tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",childId)=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)=="其他文本描述")){
								//其他文本描述给文本框赋值
		 						var Supplement=$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
		 						if (Supplement==""){
		 							Supplement=selected.text
		 						}else{
		 							Supplement=Supplement+"，"+selected.text
								 }
								 $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(Supplement)
		 						$("#"+detailId+"").blur();
							}else{
								var node = $("#"+detailId+"").tree('find', propertyid);
								$("#"+detailId+"").tree("check",node.target);
						        //展示所有父节点  
						        $(node.target).show();  
						        $(".tree-title", node.target).addClass("tree-node-targeted");  
						        //展开到该节点 
						        $("#"+detailId+"").tree("expandTo",node.target);			        
						        //如果是非叶子节点，需折叠该节点的所有子节点  
						        if (!$("#"+detailId+"").tree("isLeaf",node.target)) { 
						        	$("#"+detailId+"").tree("collapse",node.target);
								} 
							}
						}
						if (showType=="C"){
							$("#"+detailId+"").combobox("select",propertyid);
						}
						if (showType=="CB"){
							//$("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").attr("checked",true);
							$("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").click();
						}
						if (showType=="G"){ //列表4
							var rowIndex = $("#"+childId+"_G"+isTOrP).datagrid('getRowIndex', propertyid)
							$("#"+childId+"_G"+isTOrP).datagrid("checkRow",rowIndex)
						}
						if (showType=="CG"){
							//$("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").attr("checked",true);
							$("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").click();
						}
					}
					CacheDiagPropertyData={};
					CacheDiagPropertyDataNote={};
				}
			}
		})
		//左侧属性快速检索列表加载方法
		function LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc){
			//属性快速检索列表数据首先取频次表中的数据
			PreSearchText=desc.toUpperCase();
			
			setTimeout(function(){	
				DiagPropertySearch(PreSearchText,indexTemplate);
				var listArr=new Array();
				//属性快速检索列表数据再次取前台数组的数据
				for ( var oe in CacheDiagPropertyData) {

					listArr.push({"id":oe,"text":CacheDiagPropertyData[oe],"note":CacheDiagPropertyDataNote[oe]});
					
				}
				$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
				$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');
			},700)//---石萧伟加延时

			ifLoadPropertySearchGrid=true;
			/*var opts = $('#Form_DiagPropertySearchGrid').datagrid("options");
			opts.url=$URL+"?ClassName=web.DHCBL.MKB.SDSDataFrequency&QueryName=GetStructProDetail&ResultSetType=array&proTemplId="+DKBBCRowId+"&indexTemplate="+indexTemplate+"&desc="+desc;
			$('#Form_DiagPropertySearchGrid').datagrid("load");	*/	
		}
		/*****************左侧属性快速检索列表结束*******************************************/
		/*****************中间已选属性列表开始*******************************************/
		$HUI.datagrid("#Form_DiagPropertySelectedGrid",{
			columns: [[    
				{field:'index',title:'index',width:30,sortable:true,hidden:true},
				{field:'titleid',title:'属性标题id',width:60,sortable:true,hidden:true},
				{field:'title',title:'属性标题',width:80,sortable:true,
					formatter:function(value,rec){ 
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+value+"</span>" 
	                } 
				},
				{field:'text',title:'已选属性',width:200,sortable:true,
					formatter:function(value,rec){ 
						var showValue=value
						if ((value!="")&&(value!=undefined)){
							if (value.length>10){
								showValue=value.substr(0,12)+"..."
							}
						}
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+showValue+"</span>" 
	                } 
		         },
				{field:'id',title:'已选属性id',width:30,sortable:true,hidden:true}
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:100,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			sortName:'index',  
    		sortOrder:'asc',
			onClickCell:function(rowIndex, field, value){
				if (field=="title"){
					$("#DiagForm").empty();
					//var record=$("#mygrid").datagrid("getSelected")
					indexTemplate=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1];
					/*if(record && (($("#combogrid").combogrid('getValue')==record.MKBSDTermDR))){//石萧伟
						var Rowid=record.Rowid
						setTimeout(function(){
							LoadPropertyData(SelMRCICDRowid,Rowid,indexTemplate);
						},100)
					}else{*/
                        var termid = $("#combogrid").combogrid('getValue')
                        //var termid = $("#leftgrid").datagrid('getSelected').MKBTRowId
						setTimeout(function(){
						   LoadPropertyData(termid,"",indexTemplate);
					   },50)     						
					//}

					CacheDiagPropertyData={};
					CacheDiagPropertyDataNote={};	
				}
			},
			/*onClickRow:function(rowIndex, rowData){
				//选中已勾选属性内容节点效果
				var trids=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var childId=trids.split("_")[1]
				var showtype=trids.split("_")[2];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				if (tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)!="其他文本描述"){
					var nodeid=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].id
					if ((nodeid!=0)&&(showtype=="T")){
						//选中已勾选属性内容节点
						var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',nodeid); 
						$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('select',node.target); 
					}
				}
			},*/
			onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
				var $clicked=$(e.target);
				copytext =$clicked.text()||$clicked.val()   //普通复制功能
				
				e.preventDefault();  //阻止浏览器捕获右键事件
				var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
				$('#selProMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
			},
			onLoadSuccess: function(data){                      //data是默认的表格加载数据，包括rows和Total
				var mark=1;                                                 //这里涉及到简单的运算，mark是计算每次需要合并的格子数
				for (var i=1; i <data.rows.length; i++) {     //这里循环表格当前的数据
			　　　 		if(data.rows[i]['title'] == data.rows[i-1]['title']){   //后一行的值与前一行的值做比较，相同就需要合并
				　　　　	mark += 1;                                            
				　　　　　　　$(this).datagrid('mergeCells',{ 
				　　　　　　　　　　index: i+1-mark,                 //datagrid的index，表示从第几行开始合并；紫色的内容需是最精髓的，就是记住最开始需要合并的位置
				　　　　　　　　　　field: 'title',                 //合并单元格的区域，就是clomun中的filed对应的列
				　　　　　　　　　　rowspan:mark                   //纵向合并的格数，如果想要横向合并，就使用colspan：mark
				　　　　　　　}); 
			　　　　　　	}else{
			　　　　　　　		mark=1;                                         //一旦前后两行的值不一样了，那么需要合并的格子数mark就需要重新计算
			　　　　　　	}
		　　　　	}
		　}
	});
	/*****************中间已选属性列表结束*******************************************/
	//6个字符一换行方法
	function getNewline(val) {  
	    var str = new String(val);  
	    var bytesCount = 0;  
	    var s="";
	    for (var i = 0 ,n = str.length; i < n; i++) {  
	        var c = str.charCodeAt(i);  
	        //统计字符串的字符长度
	        if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {  
	            bytesCount += 1;  
	        } else {  
	            bytesCount += 2;  
	        }
	        //换行
	        s += str.charAt(i);
	        if((bytesCount>=6)&&(n!=3)){  
	        	s = s + '</br>';
	        	//重置
	        	bytesCount=0;
	        } 
	    }  
	    return s;  
	} 
	var ifFirstLoadPropertyData=true; //是否初次加载-是：true；否：false
	//诊断查找选择后初始化诊断属性列表页
	function LoadPropertyData(MRCICDRowid,Rowid,indexTemplate){
		//console.log(MRCICDRowid+","+Rowid+","+indexTemplate)
		var TreeCheckedIdStr="",ComboCheckedIdStr="",RadioCheckedIdStr="",CheckBoxCheckedIdStr="",GridCheckedIdStr=""//列表4
		//石萧伟
		/*if ((Rowid!="")){ //属性修改
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				
				var parentid=$("#leftgrid").datagrid("getSelected").Rowid;//石萧伟
				var ret=tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetData",parentid,Rowid);//石萧伟
			}
        }else{*/
            if($('#result_term_id').val() != ""){
                var ret = tkMakeServerCall("web.DHCBL.MKB.MKBStructuredData","GetReviewedData",$('#result_term_id').val(),$('#result_Ids').val());//石萧伟
            }else if(SelPropertyData!="" && $('#result_term_id').val()==""){
				var ret=SelPropertyData
			}else{
				var ret = ""
            }
		//}
		if (ret!=""){
			TreeCheckedIdStr=ret.split("^")[0];
			ComboCheckedIdStr=ret.split("^")[1];
			RadioCheckedIdStr=ret.split("^")[2];
			CheckBoxCheckedIdStr=ret.split("^")[3];
			GridCheckedIdStr = ret.split("^")[4];//列表
		}
		SelPropertyArr=[];
		var DiagFormTool='<tr id="formTemplate" style="display:none;"><td nowrap style="white-space:nowrap;word-break:nowrap" class="td_label"><label for="email">分型1</label></td></tr>'
		$("#DiagForm").append(DiagFormTool)
		var $ff=$("#DiagForm"); //table
		var $templ=$("#formTemplate"); //tr
		var RetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDiaTemplate",MRCICDRowid) 
		if (RetStr!=""){
			var RetStrArr=RetStr.split("^");
			var DKBBCRowId=RetStrArr[0]; //属性模板Id
			var emptyInfo=RetStrArr[1];
			var modeJsonInfo=$.parseJSON(RetStrArr[2]);
			if ((indexTemplate=="")||(indexTemplate==undefined)) indexTemplate=DKBBCRowId;
			if (emptyInfo=="") {
				return ;
			}
				$(modeJsonInfo).each(function(index,item){
					var childId=modeJsonInfo[index].catRowId; 
					var childDesc=modeJsonInfo[index].catDesc; 
					var childType=modeJsonInfo[index].catType; //L列表 T树形 TX文本 S引用术语类型 C下拉框
					var showType=modeJsonInfo[index].showType;  //['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					var catFlag=modeJsonInfo[index].catFlag; //Y 表示诊断展示名
					var treeNode=modeJsonInfo[index].treeNode; //起始节点
					var choiceType=modeJsonInfo[index].choiceType; //单选多选配置：S单选;D多选
					var ifRequired=modeJsonInfo[index].ifRequired; //是否必填项:Y是；N否
					var isTOrP=modeJsonInfo[index].isTOrP; //引用属性：P，引用术语:T
					
					var trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var trName=childDesc+"_"+ifRequired;
					var proSelectFlag= true;//默认单选
					if (choiceType=="D"){
						proSelectFlag= false; //根据诊断模板获取多选
					}else{
						proSelectFlag= true;
					}
					if (childType=="L"){
						if (isTOrP=="P"){
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListDetailInfo", "", childId, "0", "1000");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTPDRowId';  
							var C_textField='comDesc'; //展示名
						}else{ //术语标识
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListTermJsonForDoc", "", childId, "", "1000", "1");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc'; //中心词
						}
					}
					if (childType=="T"){
						if (isTOrP=="P"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeDetailJson&id="+treeNode+"&property="+childId
						}else{ //术语标识
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeTermJsonForDoc&id="+treeNode+"&base="+childId
						}
					}
					if ((childType=="TX")||(childType=="TA")||(childType=="R")||(childType=="CB")||(childType=="C")){
						var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
					}
					if (childType=="S"){
						if ((showType=="C")||(showType=="CB")||(showType=="CG")) { //引用术语 展示为下拉框
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseList", childId, showType, ""); 
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc';
						}
						else if (showType=="T"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&LastLevel=&property="+childId
						}
						else{
							var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
						}
					}
					if (childType=="P"){
						var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocPropertyList",childId, ""); 
						ListRetStr=eval("("+ListRetStr+")")
						if (showType=="C") {
							var C_valueField='catRowId';  
							var C_textField='catDesc';
						}
					}
					if (childType=="SS"){
						var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSSProDetailJsonForDoc&property="+childId
					}
					var tool=$templ.clone();
					tool.removeAttr("style");
					tool.removeAttr("id");
					tool.attr("id",trId);
					tool.attr("lang",trName); //201917 title
					tool.addClass("dynamic_tr");
					tool.addClass("tr_dispaly");
					$ff.append(tool);
					//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表,隐藏其他属性列表
				 	if ((indexTemplate!=undefined)&&(indexTemplate!="")&&(indexTemplate!=DKBBCRowId)){
				 		if ((trId)!=indexTemplate){
					 		$(tool).css("display","none")
					 	}else{
					 		$(tool).css("display","")
					 	}
				 	}
				
					//属性名称列设置颜色交替变换
					if (index%2==0){
						$("td",tool).css("backgroundColor","#EEFAF4")
					}else{
						$("td",tool).css("backgroundColor","#FBF9F2")
					}
					//诊断属性悬浮显示属性名
					$("td",tool).tooltip({
					    position: 'right',
					    content: '<span style="color:#fff">'+childDesc+'</span>',
					    onShow: function(){
							$(this).tooltip('tip').css({
								backgroundColor: '#666',
								borderColor: '#666'
							});
					    }
					});
					$("label",tool).removeAttr("style");
					//['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					//必填项区分
					if (ifRequired=="Y"){
						$("label",tool).html("<font color=red>*</font>"+getNewline(childDesc));
					}else{
						$("label",tool).html(getNewline(childDesc));
					}
				
					//诊断属性单击事件gss
				     $("#"+DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP).on("click",function(event){ 
						var $dynamic_tr=$(".dynamic_tr"); 
						for (var i=0;i<($dynamic_tr.length);i++){
							var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
							if (trids!=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP)
							{
								continue;
							}
							var id=trids.split("_")[0]; //诊断模板属性id
							var showtype=trids.split("_")[2];
							var tds=$("#"+trids+"").children();
							for (var j=1;j<tds.length;j++){
								//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
								var detailId=""
								var details=$("#"+trids+" td").children();
								for (var k=1;k<details.length;k++){
									if (k==1){
										detailId=details[k].id
									}
								}
								var type=detailId.split("_")[detailId.split("_").length-2];
								if (type=="T"){
									var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
									for (var k=0;k<unCheckedNodes.length;k++){
										var nodeId=unCheckedNodes[k].id;
										var node = $("#"+detailId+"").tree('find', nodeId);
                      					$("#"+node.target.id).css("display","");
									}
										$("#"+trids).css("display","table-row");
								}
							}
						}
					}); 
					var FindSelectFlag=0;
					if (showType=="TX"){
						if (childType=="S"){
							var TXText=SRetStr.split("[A]")[2];
							var TXId=SRetStr.split("[A]")[1];
						}else{
						    var TXText=TXRetStr.split("[A]")[1];
						    var TXId=TXRetStr.split("[A]")[0];
						}
						var TX_tool="<td><label id='"+childId+"_"+TXId+"_TX"+isTOrP+"'>"+TXText+"</label></td>"  
						tool.append(TX_tool);
					}
					if (showType=="TA"){
						var TAId=""
						if (childType=="S"){
							var TAText=SRetStr.split("[A]")[2];
							TAId=SRetStr.split("[A]")[1];
						}else{
							TAId=TXRetStr.split("[A]")[0];
							var TAText=TXRetStr.split("[A]")[1];
						}
						var TA_tool="<td><textarea disabled='disabled' style='width:98%;background:transparent;border:0px;' id='"+childId+"_"+TAId+"_TA"+isTOrP+"'>"+TAText+"</textarea></td>"  
						tool.append(TA_tool);
					}
					if (showType=="CB"){
						var FindSelectCBFlag=0;
						var CBRetStr = ListRetStr;
						var TA_tool="";
						for (var k=0;k<CBRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CBId=CBRetStr.data[k].MKBTRowId;
		                        var CBDesc=CBRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CBId=CBRetStr.data[k].MKBTRowId;
		                        	var CBDesc=CBRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CBId=CBRetStr.data[k].catRowId;
		                        	var CBDesc=CBRetStr.data[k].catDesc;
								}else{
									var CBId=CBRetStr.data[k].MKBTPDRowId;
		                        	var CBDesc=CBRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+RadioCheckedIdStr+"&").indexOf("&"+CBId+"&")>=0){
		                        var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"' checked='checked'/>"+"<span>"+CBDesc+"</span>"
		                    	FindSelectFlag=1;
		                    	FindSelectCBFlag=1;
		                    	ifFirstLoadPropertyData=true;
		                    	SaveSelPropertyData(index,"selpro"+trId,childDesc,CBId,CBDesc,"add")
		                    }else{
			                    var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"'/>"+"<span>"+CBDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						if (FindSelectCBFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$('input:radio').click(function (e) { 
						   ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CB")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") //切换之前先清除
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
						   		GetSelectedPropertyStr();
						   		
						   }
						})
					}
					if (showType=="CG"){
						var FindSelectCGFlag=0;
						var CGRetStr = ListRetStr 				
						var TA_tool="";
						for (var k=0;k<CGRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CGId=CGRetStr.data[k].MKBTRowId;
		                        var CGDesc=CGRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CGId=CGRetStr.data[k].MKBTRowId;
		                        	var CGDesc=CGRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CGId=CGRetStr.data[k].catRowId;
		                        	var CGDesc=CGRetStr.data[k].catDesc;
								}else{
									var CGId=CGRetStr.data[k].MKBTPDRowId;
		                        	var CGDesc=CGRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+CheckBoxCheckedIdStr+"&").indexOf("&"+CGId+"&")>=0){
		                        var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"' checked='checked'/>"+"<span>"+CGDesc+"</span>"
		                   		FindSelectFlag=1;
		                   		FindSelectCGFlag=1;
		                        ifFirstLoadPropertyData=true;	
		                        SaveSelPropertyData(index,"selpro"+trId,childDesc,CGId,CGDesc,"add")
		                    }else{
			                    var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"'/>"+"<span>"+CGDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						if (FindSelectCGFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$('input:checkbox').click(function (e) { //11
                           ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CG")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		if (e.target.checked==true){
						   			var SelPropertyType="add"
						   		}else{
						   			var SelPropertyType="remove"
						   		}
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,SelPropertyType)
						   		GetSelectedPropertyStr();
                                   //InitSmartTip("","","");
                                //SearchDataFromStrData();
						   }
						})
					}
					if (showType=="C"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Combo_tool="<td><input class='hisui-combobox' id='"+childId+"_C"+isTOrP+"' /></td>" 
						tool.append(Combo_tool);
						$HUI.combobox("#"+childId+"_C"+isTOrP+"",{
							editable: true,
							multiple:false,
							width:'250',
							//panelHeight:'auto',
							//selectOnNavigation:true,
						  	valueField:C_valueField,   
						  	textField:C_textField,
						  	data:Data,
                			formatter:function(row){ // 鼠标悬浮显示备注
						  		if (childType=="L"){ 
						  			if (isTOrP=="P"){
										if (row.MKBTPDRemark!=""){
											return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark+'">'+row.comDesc+'</span>';
										}else{
											return row.comDesc;
										}
						  			}else{ //术语标识
						  				return row.MKBTDesc;
						  			}
						  		}else if (childType=="S"){
						  			return row.MKBTDesc;
						  		}else if (childType=="P"){
						  			return row.catDesc;
						  		}else{
						  			return row.comDesc;
						  		}
							},
						  	onLoadSuccess:function(){
							  	if(ComboCheckedIdStr!=""){
							  		var id=""
								  	var text=""
								  	var ListData=$(this).combobox('getData');
								  	for (var m=0;m<ListData.length;m++){
								  		if (isTOrP=="T"){ //术语标识
								  			if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
											  	id=ListData[m].MKBTRowId
											  	text=ListData[m].MKBTDesc
											}
								  		}else{
										  	if (childType=="S"){
											  	if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
												  	id=ListData[m].MKBTRowId
												  	text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
												  	id=ListData[m].catRowId
												  	text=ListData[m].catDesc
												}
											}else{
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
												  	id=ListData[m].MKBTPDRowId
												  	text=ListData[m].comDesc
												}
											}
								  		}
								  		FindSelectFlag=1;
									}
									$(this).combobox('setValue', id);
								  	SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
									ifFirstLoadPropertyData=true;
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onShowPanel:function(){
								if(Data==""){
									$("#"+childId+"_C"+isTOrP+"").combobox("hidePanel");//没有下拉数据时，禁止下拉列表显示，防止点击空白的下拉列表后，属性列表隐藏，空白的下拉列表跑到页面左上角
								}else{
									if (Data.length < 7) {  
										$("#"+childId+"_C"+isTOrP+"").combobox('panel').height("auto"); //下拉数据较少时，下拉面板高度自适应
							        }else{
							        	$("#"+childId+"_C"+isTOrP+"").combobox('panel').height(200); 
							        }
								}
							},
							onSelect:function(record){//11
								var id=""
                				var text=""
                				if (isTOrP=="T"){
                					id=record.MKBTRowId
                					text=record.MKBTDesc;
                				}else{
                				 	if (childType=="S"){
                				 		id=record.MKBTRowId
						  				text=record.MKBTDesc;
							  		}else if (childType=="P"){
							  			id=record.catRowId
							  			text=record.catDesc;
							  		}else{
							  			id=record.MKBTPDRowId
							  			text=record.comDesc;
                                      }
                				}
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") 
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
                				GetSelectedPropertyStr();
                                //InitSmartTip("","","");
                                //SearchDataFromStrData();
							},
              				onChange:function(newValue, oldValue){//11
								if ((newValue=="")&&(ifFirstLoadPropertyData!=true)){
									SaveSelPropertyData(index,"selpro"+trId,childDesc,oldValue,"","remove") //清空下拉框数据时清除已选列表数据
									ifFirstLoadPropertyData=false;
									GetSelectedPropertyStr();//20180313bygss	
                                    //InitSmartTip("","","");
                                    //SearchDataFromStrData();
								}
							}
						});
					}
					//列表4
					if (showType=="G"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Grid_tool="<td ><table style='width:200px;max-height:200px;' id='"+childId+"_G"+isTOrP+"' border='false'></table></td>" 
						tool.append(Grid_tool);
						$HUI.datagrid("#"+childId+"_G"+isTOrP,{
							columns: [[
									{field:'ck',checkbox:true,
										styler : function(value, row, index) {
										return 'border:0;';
									}}, 
									{field:C_valueField,title:"ID",width:40,hidden:true},
									{field:C_textField,title:'描述',width:80,
										styler : function(value, row, index) {
											return 'border:0;';
										},
										formatter:function(value,row,index){ // 鼠标悬浮显示备注
											if (childType=="L"){ 
												if (isTOrP=="P"){
												  if ((row.MKBTPDRemark!="")&&(row.MKBTPDRemark!=undefined)){
													  return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark.replace(/<[^>]+>/g,"")+'">'+row.comDesc+'</span>';
												  }else{
													  return row.comDesc;
												  }
												}else{ //术语标识
													return row.MKBTDesc;
												}
											}else if (childType=="S"){
												return row.MKBTDesc;
											}else if (childType=="P"){
												return row.catDesc;
											}else{
												return row.comDesc;
											}
									    }
								}
							]],  //列信息
							showHeader:false,
							checkbox:true,
							checkOnSelect:false,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框
							selectOnCheck:false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
							pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
							singleSelect:proSelectFlag,
							idField:C_valueField, 
							rownumbers:false,    //设置为 true，则显示带有行号的列。
							fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
							remoteSort:false,  //定义是否从服务器排序数据。true
							data:Data,
							onLoadSuccess:function(data){
								if(GridCheckedIdStr!=""){
										var ListData=$(this).datagrid('getRows');
										for (var m=0;m<ListData.length;m++){
											var id=""
											var text=""
											if (isTOrP=="T"){ //术语标识
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
													id=ListData[m].MKBTRowId
													text=ListData[m].MKBTDesc
											}
											}else{
												if (childType=="S"){
													if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
														id=ListData[m].MKBTRowId
														text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
														id=ListData[m].catRowId
														text=ListData[m].catDesc
												}
											}else{
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
														id=ListData[m].MKBTPDRowId
														text=ListData[m].comDesc
												}
											}
											}
											FindSelectFlag=1;
											ifFirstLoadPropertyData=true;
											if (id!=""){
											var rowIndex=$(this).datagrid("getRowIndex",id)
											$(this).datagrid("checkRow",rowIndex)
											}
									}
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onCheck:function(rowIndex,rowData){
								var id=""
								var text=""
								if (isTOrP=="T"){
									id=rowData.MKBTRowId
									text=rowData.MKBTDesc;
								}else{
										if (childType=="S"){
											id=rowData.MKBTRowId
											text=rowData.MKBTDesc;
										}else if (childType=="P"){
											id=rowData.catRowId
											text=rowData.catDesc;
										}else{
											id=rowData.MKBTPDRowId
											text=rowData.comDesc;
										}
								}
								if (proSelectFlag==true){//单选模式
									var rows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked")
									if(rows.length>1){ 
										for (var i=0;i<rows.length;i++){
											var ids=""
											if (isTOrP=="T"){
												ids=rows[i].MKBTRowId
											}else{
													if (childType=="S"){
														ids=rows[i].MKBTRowId
													}else if (childType=="P"){
														ids=rows[i].catRowId
													}else{
														ids=rows[i].MKBTPDRowId
													}
											}
											if (ids==id) {
												continue
											}
											var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",ids)
											$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
										}
									}
								}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
								GetSelectedPropertyStr();
								//InitSmartTip("","","");
							},
							onUncheck:function(rowIndex,rowData){
								var id=""
								var text=""
								if (isTOrP=="T"){
									id=rowData.MKBTRowId
									text=rowData.MKBTDesc;
								}else{
										if (childType=="S"){
											id=rowData.MKBTRowId
											text=rowData.MKBTDesc;
										}else if (childType=="P"){
											id=rowData.catRowId
											text=rowData.catDesc;
										}else{
											id=rowData.MKBTPDRowId
											text=rowData.comDesc;
										}
								}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove") 
								ifFirstLoadPropertyData=false;
								GetSelectedPropertyStr();	
								//InitSmartTip("","","");
							}
						})
					}

					if (showType=="T"){
						if (childDesc=="文本"){
							//其他文本描述放属性列表中作为文本录入框，存到补充诊断字段
							var TA_tool="<td><textarea style='width:320px;height:80px;margin:2px' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></textarea></td>"  
							tool.append(TA_tool);
							/*if (Rowid!=""){
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val($("#mygrid").datagrid("getSelected").MKBSDSupplement)
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){//哈哈
									//根据SDSRowId修改补充诊断
			 						$.ajax({
										url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
										data:{
											"Cid":Rowid,     ///rowid
											"Supplement":$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
										},  
										type:"POST",   
										success: function(data){
												  var data=eval('('+data+')'); 
												  if (data.success == 'true') {
												  	  //UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
												  	  if ($("#mygrid").datagrid("getSelected").MKBSDSupplement!=""){
												  	  		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove")
												  	  }
												  	  ifFirstLoadPropertyData=false;
												  	  if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
												  	 		SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
												  	  }
												  } 
												  else { 
														var errorMsg ="补充诊断保存失败！"
														if (data.info) {
															errorMsg =errorMsg+ '<br/>错误信息:' + data.info
														}
														$.messager.alert('操作提示',errorMsg,"error");
												}			
										}  
									})
									
								})
							}else{//石萧伟加当rowid为空时*/
								$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){//11
									ifFirstLoadPropertyData=false;
									if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
                                           SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
                                           //SearchDataFromStrData();
									}
								})							
							//}
							
							/*if ($("#mygrid").datagrid("getSelected")&&($("#mygrid").datagrid("getSelected").MKBSDSupplement!="")&&(($("#mygrid").datagrid("getSelected").MKBSDSupplement!=undefined))){
								SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#mygrid").datagrid("getSelected").MKBSDSupplement,$("#mygrid").datagrid("getSelected").MKBSDSupplement,"add")
							}else{*/
								SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add") //初始化已选属性文本标题
							//}
						}else{
								var tmpTreeCheckedIdStr=TreeCheckedIdStr;
								var FindSelectFlag=0;
								var Tree_tool="<td width=400><ul class='hisui-tree' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></ul></td>"
								tool.append(Tree_tool);
								var tree=$HUI.tree("#"+childId+"_T"+isTOrP+"_"+treeNode+"",{
									checkbox:true,
									//onlyLeafCheck:true,
									lines:true,
									multiple:proSelectFlag,
									cascadeCheck:false,
									//data:TreeRetStr,
									url:TreeRetUrl, 
									formatter:function(node){
										if (childType=="T"){
			              					//鼠标悬浮显示备注
			                  				var remark=node.text.split("^")[3].split("</span>")[0];
											if (remark!=""){
												return '<span class="hisui-tooltip" title="'+remark+'">'+node.text+'</span>';
											}else{
												return node.text;
											}
										}else{
											return node.text;
										}
									},
									onContextMenu: function(e, node){ //诊断属性右键菜单gss   
														e.preventDefault();  //阻止右键默认事件 
													    $("#NodeMenu").empty(); //	清空已有的菜单
														$(this).tree('select',node.target);
	 
														$('#NodeMenu').menu('appendItem', {
															text:"知识点",
															iconCls:'icon-productimage',
															onclick:function(){
																var height=parseInt(window.screen.height)-120;
																var width=parseInt(window.screen.width)-50;
																if (isTOrP=="P"){
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+MRCICDRowid+"&ProId="+childId+"&detailId="+node.id; 
																}else{
																	var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																	var repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+termmenuid+"&TermID="+node.id+"&ProId="; 
																}
																var listtermWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=20,top=20,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ listtermWin.document.title = '知识点'; }, 150)
															}
														})
														$('#NodeMenu').menu('appendItem', {
															text:"关联ICD",
															iconCls:'icon-paper-link',
															onclick:function(){
																var wordVersion=tkMakeServerCall("web.DHCBL.MKB.MKBConfig","GetConfigValue","SDSDataSource");
																var height=parseInt(window.screen.height)-150;
																var width=parseInt(window.screen.width)-80;
																var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id+"&version="+wordVersion+"&dblflag=N&DiagnosValue="; 
																var relatedicdWin=window.open(repUrl,"_blank","height="+height+",width="+width+",left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ relatedicdWin.document.title = '关联ICD'; }, 100)
															}
														})
														$('#NodeMenu').menu('appendItem', {
															text:"相关文献",
															iconCls:'icon-paper',
															onclick:function(){
								                            	var repUrl="dhc.bdp.mkb.mkbrelateddocuments.csp?diag="+MRCICDRowid+"-"+childId+":"+node.id; 
																var documentsWin=window.open(repUrl,"_blank","height=600,width=1000,left=50,top=50,resizable=yes,titlebar=no,toolbar=no,menubar=no,scrollbar=no,location=no,status=no",true)
																setTimeout(function(){ documentsWin.document.title = '相关文献'; }, 100)
															}
														})
														$('#NodeMenu').menu('show', {    
															left: e.pageX+10,    
															top: e.pageY+5   
														}); 
											}, 
									onClick:function(node){
										if (node.checked){
											$(this).tree('uncheck',node.target)  
										}else{
											$(this).tree('check',node.target)  
										}
										//SearchDataFromStrData();
									},
									onCheck:function(node, checked){//11
										var SelPropertyType=""
										if (checked==true){
											if (node.checked==false){
												SelPropertyType="add"
											}
										}else{
											SelPropertyType="remove"
										}
										ifFirstLoadPropertyData=false;
										if (proSelectFlag==false){//多选模式
											if (checked){
											   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
											}
										}else{
											var nodes =$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getChecked');
											if(nodes.length>1){ 
												for (var i=0;i<nodes.length;i++){
													var ids=nodes[i].id;
													if (ids==node.id) {
													
														continue
													}
													var node1 = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',ids); 
													$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node1.target);
												}
										    }
											   
										}
										//获取当前选中节点的所有父节点 concat
										 var parentAll = "";
										 parentAll = node.text.split("<span class='hidecls'>")[0];
										 var flag = "，";
										 var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',node.id).target); //获取选中节点的父节点
										 for (n = 0; n < 6; n++) { //可以视树的层级合理设置k
										     if (parent != null) {
										         parentAll = flag.concat(parentAll);
										         parentAll = (parent.text.split("<span class='hidecls'>")[0]).concat(parentAll);
										         var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', parent.target);
										     }
										 }
										 parentAll=parentAll.split("，").reverse().join("，"); //父子级倒序显示
										 if (SelPropertyType=="add"){
                                            
											SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										 else if(SelPropertyType=="remove"){
										 	SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										GetSelectedPropertyStr();//gssby20180302
                                        //InitSmartTip("","","");
                                        //SearchDataFromStrData();
									},	
									onLoadSuccess:function(node, data){
										//$('.mytooltip').tooltip();
										var Roots=$(this).tree('getRoots');
										for (var j=0;j<Roots.length;j++){
											if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
										}
										
										if (TreeCheckedIdStr!=""){
											for (var m=0;m<TreeCheckedIdStr.split("&").length;m++){
												var tmpnode = $(this).tree('find', TreeCheckedIdStr.split("&")[m]);
												if (tmpnode){
													$(this).tree('check', tmpnode.target);
													$(this).tree("expandTo",tmpnode.target);
													FindSelectFlag=1;
													ifFirstLoadPropertyData=true;
												}
											}
										}
										
										for (var j=0;j<Roots.length;j++){
												if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
										}
										
										tmpTreeCheckedIdStr="";
										SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
										//去掉treegrid结点前面的文件及文件夹小图标
										//$("#"+childId+"_T_"+treeNode+".tree-icon,#"+childId+"_T_"+treeNode+" .tree-file").removeClass("tree-icon tree-file");
										//$("#"+childId+"_T_"+treeNode+" .tree-icon,#"+childId+"_T_"+treeNode+" .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
									}
								})
						}
					}
					if (FindSelectFlag==1){
						ifFirstLoadPropertyData=true;
						$("#"+DKBBCRowId+"_"+childId+"_"+showType+isTOrP+"").removeClass("tr_dispaly");
						$("#"+childId+"_Empty_CG").attr('checked',true);
					}
				})
            //石萧伟
            /*if (findCondition==""){
                findCondition=$('.combogrid-f').combo("getText");
            }else{
                setTimeout(function(){
                    findCondition=$('.combogrid-f').combo("getText");
                    //alert(findCondition)
                },50)
            }*/
            findCondition = $("#combogrid").combogrid('getValue') //$('#leftgrid').datagrid('getSelected').MKBTDesc				
			/*****************左侧属性快速检索列表开始*******************************************/
			LoadFormPropertySearchData(DKBBCRowId,indexTemplate,"")
			//属性列表检索框定义
			 $('#Form_DiagPropertySearchText').searchbox({
			   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
					if (emptyInfo!=""){
						PreSearchText=value.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,value)
					}else{
						$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
					}
			   }
			})
			$('#Form_DiagPropertySearchText').searchbox('setValue','')
			$('#Form_DiagPropertySearchText').searchbox('textbox').focus();
			//属性列表检索框实时检索
			var flagPropertyTime=""
			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keyup').keyup(function(e){  
				if (emptyInfo!=""){
					clearTimeout(flagPropertyTime);
					flagPropertyTime=setTimeout(function(){
						var desc=$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
						PreSearchText=desc.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc)
					},800)
				}else{
					$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
				}
   			}); 	
 			$('#Form_DiagPropertySearchText').searchbox('textbox').bind('click',function(){ 
 				$('#Form_DiagPropertySearchText').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
 			});
 			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keydown').keydown(function(e){
 				//单击其他描述获取到的属性检索列表，输入检索条件enter保存到知识库其他描述-其他文本描述节点下，同时修改到补充诊断字段
 				if ((e.keyCode == 13)&&(indexTemplate.indexOf("_")>-1)&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",indexTemplate.split("_")[1])=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",indexTemplate.split("_")[4])=="其他文本描述")){
 						//保存到知识库其他文本描述节点下
 						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=AddDataToOtherTextPro",   
							data:{
								"proId":indexTemplate.split("_")[1],     ///rowid
								"text":$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
							},  
							type:"POST",   
							success: function(data){
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  } 
									  else { 
											var errorMsg ="同步知识库文本失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											$.messager.alert('操作提示',errorMsg,"error");
									}			
							}  
						})
 						
 						//其他文本描述赋值
 						var Supplement=$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val()
 						if (Supplement==""){
 							Supplement=$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}else{
 							Supplement=Supplement+"，"+$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}
 						$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val(Supplement)
 						//根据SDSRowId修改补充诊断
 						var index=""
 						var trId=""
 						$(modeJsonInfo).each(function(i,item){
 							var childId=modeJsonInfo[i].catRowId; 
							var childDesc=modeJsonInfo[i].catDesc; 
							var childType=modeJsonInfo[i].catType; 
							var showType=modeJsonInfo[i].showType;  
							var treeNode=modeJsonInfo[i].treeNode; 
							var isTOrP=modeJsonInfo[i].isTOrP; 
							if (childDesc=="文本"){
								index=i
								trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
								return;
							}
 						})
 						SaveSelPropertyData(index,"selpro"+trId,"文本","","","remove")
 						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
							data:{
								"Cid":Rowid,     ///rowid
								"Supplement":Supplement
							},  
							type:"POST",   
							success: function(data){
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  	  //UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);
									  	  SaveSelPropertyData(index,"selpro"+trId,"文本",Supplement,Supplement,"add")
									  } 
									  else { 
											var errorMsg ="补充诊断保存失败！"
											if (data.info) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.info
											}
											$.messager.alert('操作提示',errorMsg,"error");
									}			
							}  
						})
 				}
 			})
 			/*****************左侧属性快速检索列表结束*******************************************/
		}
		ChangePropertyShow("",indexTemplate);
	}

	//已选属性列表 右键复制按钮
	$("#CopySelPro").click(function (e) { 
		var aux=document.getElementById("Form_DiagPropertySelCopyText"); 
		aux.value=copytext; //赋值
		aux.select(); // 选择对象 
		document.execCommand("Copy"); // 执行浏览器复制命令 
	 })
	 //已选属性列表 右键删除按钮 取消勾选
	$("#DelSelPro").click(function (e) { 
		var record=$("#Form_DiagPropertySelectedGrid").datagrid("getSelected")
		var index=record.index;
		var trId=record.titleid
		var childDesc=record.title
		var id=record.id;
		var trids=record.titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
		var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
		var childId=trids.split("_")[1]
		var showtype=trids.split("_")[2];
		var childType=trids.split("_")[3];
		var treeNode=trids.split("_")[4];
		var isTOrP=trids.split("_")[5];
		if (showtype=="T"){ //树形
			if (childDesc=="文本"){
				//根据SDSRowId清空补充诊断
				//$.ajax({
				//	url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBStructuredData&pClassMethod=UpdateSupplement",   
					//data:{
					//	"Cid":$("#mygrid").datagrid("getSelected").Rowid,     ///rowid
						//"Supplement":""
					//},  
					//type:"POST",   
					//success: function(data){
							 // var data=eval('('+data+')'); 
							  //if (data.success == 'true') {
									//UpdataRow(mygrid.getRowIndex($("#mygrid").datagrid("getSelected")),data.id);	
								  var MKBSDSupplement = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
							  	  $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val("")
							  	  ifFirstLoadPropertyData=false;
							  	  SaveSelPropertyData(index,"selpro"+trId,childDesc,MKBSDSupplement,"","remove")
							//   } 
							//   else { 
							// 		var errorMsg ="补充诊断保存失败！"
							// 		if (data.info) {
							// 			errorMsg =errorMsg+ '<br/>错误信息:' + data.info
							// 		}
							// 		$.messager.alert('操作提示',errorMsg,"error");
							// }			
					//}  
				//})
			}else{
				var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',id); 
				$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node.target);
			}
		}
		if (showtype=="C"){ //下拉框
			$("#"+childId+"_C"+isTOrP+"").combobox('setValue', "");
		}
		if (showtype=="G"){ //列表4
			var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",id)
			$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
		}
		if (showtype=="CB"){ //单选框
			$("#"+childId+"_"+id+"_CB"+isTOrP+"").prop('checked','');
			SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
		}
		if (showtype=="CG"){ //多选框
			$("#"+childId+"_"+id+"_CG"+isTOrP+"").prop('checked','');
			SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
		}
	})
	function SpliceSelProperty(pindex,pid,type){
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				if (type=="add"){
					if(obj.id==""){ //清除标题行
						SelPropertyArr.splice(i,1)
					}
				}else{
					if (pid==""){ //清除所有
						SelPropertyArr.splice(i,1)
					}else{
						if (pid==obj.id){ //清除当前选中
							SelPropertyArr.splice(i,1)
						}
					}
				}
			}
		}
	}
	function GetSelPropertyNum(pindex){
		var num=0;
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				num++;	
			}
		}
		return num;
	}
	//属性列表勾选对已选列表赋值
	function SaveSelPropertyData(pindex,ptitleid,ptitle,pid,ptext,type){
		if(type=="add")
		{
	 	 	SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":ptext,"id":pid});
	 	 	SpliceSelProperty(pindex,pid,type);
	 	 	if((GetSelPropertyNum(pindex)==0)&&(pid=="")){
	 	 		SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
	 	 	}
	 	 	$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
		}
		if(type=="remove")
		{
			SpliceSelProperty(pindex,pid,type);
			if(GetSelPropertyNum(pindex)==0){
				SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
			}
			$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
		}
		if(indexTemplate!=undefined){
			//选中已选属性列表行
			var data=$('#Form_DiagPropertySelectedGrid').datagrid('getData')
			for (var i=0; i <data.rows.length; i++) { 
	 			if (data.rows[i]['titleid']=="selpro"+indexTemplate){
					$('#Form_DiagPropertySelectedGrid').datagrid('selectRow', i); //选中对应的行
					return;
				}
	 		}
		}else{
			$('#Form_DiagPropertySelectedGrid').datagrid('clearSelections')
		}
	}

	//仅显示已选择属性功能
	function ChangePropertyShow(showtypepara,indexTemplate){
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
					for (var k=0;k<unCheckedNodes.length;k++){
						var nodeId=unCheckedNodes[k].id;
						var node = $("#"+detailId+"").tree('find', nodeId);
						if (showtypepara=="on"){
	            			$("#"+node.target.id).css("display","none");
						}else{
	              			$("#"+node.target.id).css("display","");
						}
					}
					if (showtypepara=="on"){
						var CheckedNodes = $("#"+detailId+"").tree('getChecked');
						if (CheckedNodes.length==0){
							$("#"+trids).css("display","none");
						}else{
							$("#"+trids).css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="C"){
					var ComboData=$("#"+detailId+"").combobox('getValue');
					if (ComboData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="G"){ //列表4
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getChecked');
					if (GridData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}				
				if (showtype=="CB"){
					var Find=0;
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						if (!$("#"+radioId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+radioId+"").css("display","none");
								$("#"+radioId+"").next().css("display","none");
							}else{
								$("#"+radioId+"").css("display","");
								$("#"+radioId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="CG"){
					var Find=0;
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						if (!$("#"+checkboxId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+checkboxId+"").css("display","none");
								$("#"+checkboxId+"").next().css("display","none");
							}else{
								$("#"+checkboxId+"").css("display","");
								$("#"+checkboxId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				
			}
		}
	}
	
	//获取已选属性
	function GetSelectedPropertyStr(){
		var menuItemValueMap = {};
		var SelectedPropertyStr="";
		var SelectedPropertyDesc="";
		var SelectedPropertyName="";
		var Supplement=""
		var TreeCheckedIdStr=""
		var ComboCheckedIdStr=""
		var RadioCheckedIdStr=""
		var CheckBoxCheckedIdStr=""
		var GridCheckedIdStr=""//列表4
		var $dynamic_tr=$(".dynamic_tr");
		for (var i=0;i<($dynamic_tr.length);i++){
			(function(i){
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1];
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var tds=$("#"+trids+"").children();
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					if (showtype=="T"){
						if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
							var oneSelectedPropertyParentAll=""
							var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
							for (var k=0;k<treeCheckedIds.length;k++){
								var OneTreeCheckedId=treeCheckedIds[k].id;
								/*var oneTreeCheckedDesc=treeCheckedIds[k].target.innerText
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("^")[0]*/
								var oneTreeCheckedDesc=treeCheckedIds[k].text;
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("<span class='hidecls'>")[0];
								if (OneTreeCheckedId!=""){
									if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
									}else{
										var OneTreeCheckedIdItem=OneTreeCheckedId
									}
									if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
									else menuItemValueMap[childId]=OneTreeCheckedIdItem
								}
								if (TreeCheckedIdStr=="") TreeCheckedIdStr=OneTreeCheckedId
								else TreeCheckedIdStr=TreeCheckedIdStr+"&"+OneTreeCheckedId
								
							}
						}
					}
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						var ComboSelText=$("#"+detailId+"").combobox('getText');
						if (ComboSelId!=""){
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem
							if (ComboCheckedIdStr=="") ComboCheckedIdStr=ComboSelId
							else ComboCheckedIdStr=ComboCheckedIdStr+"&"+ComboSelId
						}
					}
					//列表4
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
								else menuItemValueMap[childId]=GridSelIdItem
								if (GridCheckedIdStr=="") GridCheckedIdStr=gridId
								else GridCheckedIdStr=GridCheckedIdStr+"&"+gridId
							}
						}
					}

					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var obj=$('input[name='+radioName+']:checked');
						var CheckedObj=obj[0];
						if(CheckedObj!=undefined){
							var CBSelId=CheckedObj.id.split("_")[1];
							var CBSelDesc=obj.next().text();
							if (CBSelId!=""){
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
								else menuItemValueMap[childId]=CBSelIdItem
								if (RadioCheckedIdStr=="") RadioCheckedIdStr=CBSelId
								else RadioCheckedIdStr=RadioCheckedIdStr+"&"+CBSelId
							}
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
								var CGSelId=CheckedObj[m].id.split("_")[1];
								var CGSelDesc=$("#"+CheckedObj[m].id+"").next().text();
								if (CGSelId!=""){
									if (childType=="S"){
										var CGSelIdItem="S"+CGSelId
									}else{
										var CGSelIdItem=CGSelId
									}
									if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
									else menuItemValueMap[childId]=CGSelIdItem
									if (CheckBoxCheckedIdStr=="") CheckBoxCheckedIdStr=CGSelId
									else CheckBoxCheckedIdStr=CheckBoxCheckedIdStr+"&"+CGSelId
								}
							}
						}
					}
				}
			})(i)
		}
	    for ( var mv in menuItemValueMap) {
		    if (SelectedPropertyStr=="") SelectedPropertyStr=mv+":"+menuItemValueMap[mv];
		    else SelectedPropertyStr=SelectedPropertyStr+","+mv+":"+menuItemValueMap[mv];
		}
		SelPropertyData=TreeCheckedIdStr+"^"+ComboCheckedIdStr+"^"+RadioCheckedIdStr+"^"+CheckBoxCheckedIdStr
		return SelectedPropertyStr;
	}
	function GetParamStr(termid){
		if (termid==""){
			var info=$("#SelMKBRowId").val();
		}else{
			var info=termid
		}
		if (info=="") return false;
		var newPropertyStr=""
		var SelectedPropertyStr=GetSelectedPropertyStr();
		for (var k=0;k<SelectedPropertyStr.split(",").length;k++){
			if (SelectedPropertyStr.split(",")[k]=="") continue;
			if (newPropertyStr=="") newPropertyStr=info+"-"+SelectedPropertyStr.split(",")[k];
			else newPropertyStr=newPropertyStr+","+SelectedPropertyStr.split(",")[k];
		}
		if (newPropertyStr=="") newPropertyStr=info;
		return newPropertyStr
	}
	//获取属性相关信息 ；flagFrequency：属性列表勾选是否记频次标识
	function GetPropertyValue(flagFrequency){
		GetSelectedPropertyStr();//石萧伟
		var menuItemValueMap = {};
		var TreeDataStr="";
		var ComboDataStr="";
		var RadioDataStr="";
		var CheckDataStr="";
		var DataStr="";
		var resultRequired="" //必填项未维护结果集
		var Supplement=""; //补充诊断
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			(function(i){
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var id=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1]; //属性id
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];//起始节点的id
				var isTOrP=trids.split("_")[5];//术语属性标识
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var ifRequired=$dynamic_tr[i].lang.split("_")[1] //是否必填项 //201917
				var tds=$("#"+trids+"").children();
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					if (showtype=="T"){
						if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
							//获取显示方式为树类型的选择节点串
							var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
							for (var k=0;k<treeCheckedIds.length;k++){
								var OneTreeCheckedId=treeCheckedIds[k].id;
								if (treeCheckedIds[k].text.indexOf("<span class='hidecls'>")>0){
									var OneText=treeCheckedIds[k].text.split("<span class='hidecls'>")[1].split("</span>")[0];
									var Onedisplayname=OneText.split("^")[2]; //展示名
								}else{
									var OneText=treeCheckedIds[k].text
								}
								if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
								}else{
									var OneTreeCheckedIdItem=OneTreeCheckedId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
								else menuItemValueMap[childId]=OneTreeCheckedIdItem
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var OneTreeCheckedDesc=treeCheckedIds[k].text.split("<span class='hidecls'>")[0]
									//DHCDocUseCount(trids+"#"+OneTreeCheckedId, OneTreeCheckedDesc,"User.SDSStructDiagnosProDetail"+id)
								}
							}
							if (treeCheckedIds==""){
								if (ifRequired=="Y"){
									//必填项未维护结果集
									if (resultRequired=="") resultRequired=childDesc
									else resultRequired=resultRequired+","+childDesc
								}
							}
						}
					}
					//列表4
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
								else menuItemValueMap[childId]=GridSelIdItem
							}

						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc	
							}
						}
					}

					//下拉框
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						if ((ComboSelId!="")&(ComboSelId!=undefined)){
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
								var ComboSelDesc=$("#"+detailId+"").combobox('getText')
								//DHCDocUseCount(trids+"#"+ComboSelId, ComboSelDesc,"User.SDSStructDiagnosProDetail"+id)
							}
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc		
							}
						}
					}
					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var CheckedObj=$('input[name='+radioName+']:checked')[0];
						if(CheckedObj!=undefined){
							var CBSelId=CheckedObj.id.split("_")[1];
							if (CBSelId!=""){
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var CBSelDesc=$('input[name='+radioName+']:checked').next().text()
									//DHCDocUseCount(trids+"#"+CBSelId, CBSelDesc,"User.SDSStructDiagnosProDetail"+id)
								}
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
								else menuItemValueMap[childId]=CBSelIdItem
							}
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc		
							}
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
								var CGSelId=CheckedObj[m].id.split("_")[1];
								if (childType=="S"){
									var CGSelIdItem="S"+CGSelId
								}else{
									var CGSelIdItem=CGSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
								else menuItemValueMap[childId]=CGSelIdItem
							}
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
								$('input[name='+checkboxName+']:checked').each(function(n){
									var CGSelIdF=$('input[name='+checkboxName+']:checked')[n].id.split("_")[1]
									var CGSelDescF=$(this).next().text()
									//DHCDocUseCount(trids+"#"+CGSelIdF, CGSelDescF,"User.SDSStructDiagnosProDetail"+id)
								})
							}
						}else{
							if (ifRequired=="Y"){
								//必填项未维护结果集
								if (resultRequired=="") resultRequired=childDesc
								else resultRequired=resultRequired+","+childDesc	
							}
						}
					}
				}
			})(i)
		}
		for ( var mv in menuItemValueMap) {
		    if (DataStr=="") DataStr=mv+":"+menuItemValueMap[mv];
		    else DataStr=DataStr+","+mv+":"+menuItemValueMap[mv];
		}
		if (SelMRCICDRowid!=""){
			var DiagnosPropertyStr=SelMRCICDRowid+"#"+DataStr+"#"+Supplement+"#"+resultRequired;
		}else{
			var DiagnosPropertyStr="";
		}
		if (DiagnosPropertyStr=="") return "";
		return DiagnosPropertyStr;
	}
	
	//快速检索前台获取数据
	function DiagPropertySearch(SearchText,indexTemplate){
		CacheDiagPropertyData={};
		CacheDiagPropertyDataNote={};
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			var PerfectMatchId="";
			var MatchNum=0;
			var PerfectMatchNum=0;
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					if (childDesc=="文本"){
						var TextStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocOtherTextDescStr",treeNode)
						if (TextStr!=""){
							var TextStrArr=TextStr.split("[A]");
							for (var k=0;k<TextStrArr.length;k++){
								var TextDetailId=TextStrArr[k].split("^")[0]
								var TextDetailDesc=TextStrArr[k].split("^")[1]
								if(TextDetailDesc != undefined){//石萧伟加判断
									if (TextDetailDesc.indexOf(SearchText)>=0){
										CacheDiagPropertyData[trids+"#"+TextDetailId]=TextDetailDesc; //cache
									}
								}
							}
						}
					}else{
						$("#"+detailId+"").tree("search",trids+"^"+SearchText)
						//检索码>展示名>分型描述>别名 【模糊查找】  查找优先级
						//var treeData=$("#"+detailId+"").tree("options").data;
					}
				}
				if (showtype=="C"){
					var ComboData=$("#"+detailId+"").combobox('getData');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTPDRowId;
							var ComboText=ComboData[k].comDesc; //TKBTDDesc
		          			var ComboPYText=ComboData[k].PYDesc.toUpperCase(); //20180315bygss
							var ComboRemark=ComboData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if ((ComboText.indexOf(SearchText)>=0)||(ComboPYText.indexOf(SearchText)>=0)){
									//鼠标悬浮显示备注
									/*if (ComboRemark!=""){
										CacheDiagPropertyData[trids+"#"+ComboId]='<span class="hisui-tooltip" title="'+ComboRemark+'">'+ComboText+'</span>'//ComboText; //cache
									}else{
										CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									}*/
									CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									if (ComboRemark!=""){
										CacheDiagPropertyDataNote[trids+"#"+ComboId]=ComboRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{//检索条件为空
								CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
								if (ComboRemark!=""){
									CacheDiagPropertyDataNote[trids+"#"+ComboId]=ComboRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTRowId ;
							var ComboText=ComboData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (ComboText.indexOf(SearchText)>=0){
									CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{
								CacheDiagPropertyData[trids+"#"+ComboId]=ComboText; //cache
							}
						}
					}
				}
				//单选框
				if (showtype=="CB"){
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						var radioText=$("#"+radioId+"").next()[0].innerText;
						if (SearchText!=""){
							if (radioText.indexOf(SearchText)>=0){
								CacheDiagPropertyData[trids+"#"+radioId.split("_")[1]]=radioText; //cache
								PerfectMatchNum=PerfectMatchNum+1;
							}else{
								/*$("#"+radioId+"").css("display","none");
								$("#"+radioId+"").next().css("display","none");*/
							}
							if (SearchText==radioText){
								PerfectMatchId=radioId;
							}
							/*if (PerfectMatchId!=""){
								$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									$("#"+trids+"").css("display","none");
								}
							}*/
						}else{//检索条件为空
							CacheDiagPropertyData[trids+"#"+radioId.split("_")[1]]=radioText; //cache
							/*$("#"+radioId+"").css("display","");
						    $("#"+radioId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
				//列表4
				if (showtype=="G"){
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getRows');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTPDRowId;
							var GridText=GridData[k].comDesc; //TKBTDDesc
		          			var GridPYText=GridData[k].PYDesc.toUpperCase(); //20180315bygss
							var GridRemark=GridData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if ((GridText.indexOf(SearchText)>=0)||(GridPYText.indexOf(SearchText)>=0)){
									CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
									if (GridRemark!=""){
										CacheDiagPropertyDataNote[trids+"#"+GridId]=GridRemark; 
									}
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{//检索条件为空
								CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
								if (GridRemark!=""){
									CacheDiagPropertyDataNote[trids+"#"+GridId]=GridRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTRowId ;
							var GridText=GridData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (GridText.indexOf(SearchText)>=0){
									CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{
								CacheDiagPropertyData[trids+"#"+GridId]=GridText; //cache
							}
						}
					}
				}

				//多选框
				if (showtype=="CG"){
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						var checkboxText=$("#"+checkboxId+"").next()[0].innerText;
						if (SearchText!=""){
							if (checkboxText.indexOf(SearchText)>=0){
								CacheDiagPropertyData[trids+"#"+checkboxId.split("_")[1]]=checkboxText; //cache
								PerfectMatchNum=PerfectMatchNum+1;
							}else{
								/*$("#"+checkboxId+"").css("display","none");
								$("#"+checkboxId+"").next().css("display","none");*/
							}
							if (SearchText==checkboxText){
								PerfectMatchId=checkboxId;
							}
							if (PerfectMatchId!=""){
								//$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									//$("#"+trids+"").css("display","none");
								}
							}
						}else{//检索条件为空
							CacheDiagPropertyData[trids+"#"+checkboxId.split("_")[1]]=checkboxText;
							/*$("#"+checkboxId+"").css("display","");
						    $("#"+checkboxId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
			}
		}
		if (SearchText==""){
			//$("tr[id*='_']").css("display","table-row");
		}else{
			//$("tr[id*='_']").css("display","none");
		}
		/*if(sum==$dynamic_tr.length){
			return true
		}else{
			return false
		}*/
	}
	
/** 
 * 1）扩展jquery hisui tree的节点检索方法。使用方法如下： 
 * $("#treeId").tree("search", searchText);   
 * 其中，treeId为hisui tree的根UL元素的ID，searchText为检索的文本。 
 * 如果searchText为空或""，将恢复展示所有节点为正常状态 
 */ 
	$.extend($.fn.tree.methods, {  
        /** 
         * 扩展hisui tree的搜索方法 
         * @param tree hisui tree的根DOM节点(UL节点)的jQuery对象 
         * @param searchText 检索的文本 
         * @param this-context hisui tree的tree对象  trids+"^"+SearchText
         */  
        search: function(jqTree, str) {
	        var trids=str.split("^")[0];
	        var searchText=str.split("^")[1];
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
            //如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText);  
            /*if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show(); 
                    tree.collapse(jqTree, nodeList[i].target); 
                }  
                //展开已选择的节点（如果之前选择了）  
                var selectedNode = tree.getChecked(jqTree);  
                if (selectedNode) { 
                	for (var i=0;i<selectedNode.length;i++){
	                	 tree.expandTo(jqTree, selectedNode[i].target);  //
	                }
                }
                return;  
            } **/
            //搜索匹配的节点并高亮显示  
            var matchedNodeList = [];  
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];  
                   	if(searchText!=""){
	                    if (isMatch(searchText, node.text)) {  
	                        //matchedNodeList.push(node);  
	                        var text=node.text.split("<span class='hidecls'>")[0];
	                    	//20180317bygss 鼠标悬浮显示备注
	                        var remark=node.text.split("^")[3].split("</span>")[0]
	                        /*if (remark!=""){
	                        	CacheDiagPropertyData[trids+"#"+node["id"]]='<span class="hisui-tooltip" title="'+remark+'">'+text+'</span>' //text; //cache
	                        }else{
	                        	CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
	                        }*/
	                        CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
	                        if (remark!=""){
	                        	CacheDiagPropertyDataNote[trids+"#"+node["id"]]=remark; //cache
	                        }
	                    } 
                   	}else{//检索条件为空
                   		var text=node.text.split("<span class='hidecls'>")[0];
                        var remark=node.text.split("^")[3].split("</span>")[0]
                        CacheDiagPropertyData[trids+"#"+node["id"]]=text; //cache
                        if (remark!=""){
                        	CacheDiagPropertyDataNote[trids+"#"+node["id"]]=remark; //cache
                        }
                   	}
                }  
                  
                //隐藏所有节点  
                /*for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                //折叠所有节点  
                tree.collapseAll(jqTree);  
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                } */ 
            }      
        },  
        /** 
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了） 
         * @param node hisui tree节点 
         */  
        showChildren: function(jqTree, node) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //展示子节点  
            if (!tree.isLeaf(jqTree, node.target)) {  
                var children = tree.getChildren(jqTree, node.target);  
                if (children && children.length>0) {  
                    for (var i=0; i<children.length; i++) {  
                        if ($(children[i].target).is(":hidden")) {  
                            $(children[i].target).show();  
                        }  
                    }  
                }  
            }     
        },  
        /** 
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
         * @param param { 
         *    treeContainer: hisui tree的容器（即存在滚动条的树容器）。如果为null，则取hisui tree的根UL节点的父节点。 
         *    targetNode:  将要滚动到的hisui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //如果node为空，则获取当前选中的node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);  
              
            if (targetNode != null) {  
                //判断节点是否在可视区域                 
                var root = tree.getRoot(jqTree);  
                var $targetNode = $(targetNode.target);  
                var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();  
                var containerH = container.height();  
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;  
                if (nodeOffsetHeight > (containerH - 30)) {  
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;  
                    container.scrollTop(scrollHeight);  
                }                             
            }  
        }  
    });  
    /** 
     * 展示搜索匹配的节点 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //展示所有父节点  
        $(node.target).show();  
        //return false;
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //展开到该节点  
        tree.expandTo(jqTree, node.target);  
        //如果是非叶子节点，需折叠该节点的所有子节点  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
    /** 
     * 判断searchText是否与targetText匹配 
     * @param searchText 检索的文本 
     * @param targetText 目标文本 
     * @return true-检索的文本与目标文本匹配；否则为false. 
     */  
    function isMatch(searchText, targetText) {
	    searchText=searchText.toUpperCase() ;
    	var text=targetText.split("<span class='hidecls'>")[0];
    	var text2=targetText.split("<span class='hidecls'>")[1];
    	if (text2!=""){
	    	var tmpsearchtext=text2.split("</span>")[0];
			var searchCode=tmpsearchtext.split("^")[1]; //检索码
			var othername=tmpsearchtext.split("^")[0]; //别名
			var displayname=tmpsearchtext.split("^")[2]; //展示名
			
			return $.trim(text)!="" && (text.toUpperCase().indexOf(searchText)!=-1 || searchCode.toUpperCase().indexOf(searchText)!=-1 ||othername.toUpperCase().indexOf(searchText)!=-1 || displayname.toUpperCase().indexOf(searchText)!=-1)  
	    }else{
		    return $.trim(text)!="" && text.indexOf(searchText)!=-1;  
		}
    }  
    /** 
     * 获取hisui tree的所有node节点 
     */  
    function getAllNodes(jqTree, tree) {  
        var allNodeList = jqTree.data("allNodeList");  
        if (!allNodeList) {  
            var roots = tree.getRoots(jqTree);  
            allNodeList = getChildNodeList(jqTree, tree, roots);  
            jqTree.data("allNodeList", allNodeList);  
        }  
        return allNodeList;  
    } 
    /** 
     * 定义获取hisui tree的子节点的递归算法 
     */  
    function getChildNodeList(jqTree, tree, nodes) {  
        var childNodeList = [];  
        if (nodes && nodes.length>0) {             
            var node = null;  
            for (var i=0; i<nodes.length; i++) {  
                node = nodes[i];  
                childNodeList.push(node);  
                if (!tree.isLeaf(jqTree, node.target)) {  
                    var children = tree.getChildren(jqTree, node.target);  
                    childNodeList = childNodeList.concat(getChildNodeList(jqTree, tree, children));  
                }  
            }  
        }  
        return childNodeList;  
    }  
    
    // 扩展datagrid:动态添加删除editor  
	$.extend($.fn.datagrid.methods, {  
	    addEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item.field);  
	                e.editor = item.editor;  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param.field);  
	            e.editor = param.editor;  
	        }  
	    },  
	    removeEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item);  
	                e.editor = {};  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param);  
	            e.editor = {};  
	        }  
	    }  
	});  
    /******************************属性列表功能结束************************************************/

       //加载当前状态
    //mradm^短语dr^短语描述(或简拼)^Termdr^ResultID^补充诊断^ICD代码^ICD描述^结构化诊断描述 //20190828  ^界面标识   
    setTimeout(function(){
        $('#push_adm_id').val(SDSStr.split("^")[0])
        $('#push_dia_id').val(SDSStr.split("^")[1])
        $('#result_dia_id').val(SDSStr.split("^")[1])
		//$('#textDiaDr').combobox('setValue',SDSStr.split("^")[1])
		$('#textDiaDr').val(SDSStr.split("^")[2])
        
        $('#textDia').text(SDSStr.split("^")[2]);
        /*if(SDSStr.split("^")[1] == ""){
            $('#textDiaDr').combobox('setText',SDSStr.split("^")[2])
        }*/

        $('#result_term_id').val(SDSStr.split("^")[3])
        $('#push_term_id').val(SDSStr.split("^")[3])

        $('#result_Ids').val(SDSStr.split("^")[4])
        $('#push_result_Ids').val(SDSStr.split("^")[4])

        $('#result_supplement').val(SDSStr.split("^")[5])
        $('#push_result_supplement').val(SDSStr.split("^")[5])

        $('#push_icd_id').val('') /** 点击上报不再传icd的id 2019-08-12*/
		$('#result_icd_id').val('')/** 点击上报不再传icd的id 2019-08-12*/

		//LoadICDData(SDSStr.split("^")[8],$('#textICDDr'));//加载下拉框
        $('#textICDDr').val(SDSStr.split("^")[7])

		$('#textICDDesc').text(SDSStr.split("^")[7])

        $('#textICDCode').text(SDSStr.split("^")[6])
        $('#textICDCode2').val(SDSStr.split("^")[6])

        $('#textResult').text(SDSStr.split("^")[8])
		$('#textResult2').val(SDSStr.split("^")[8])

		pageType = SDSStr.split("^")[9]
		if(pageType == "SD"){
			$('#same_grid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetSDList",
				diag:SDSStr.split("^")[2],
				icd:SDSStr.split("^")[7],
				result:SDSStr.split("^")[8],
				termid:SDSStr.split("^")[3],
				icdcode:$('#textICDCode2').val()
			}); 
	
		}else{
			$('#textDiaDr').attr('readonly',true);
			$('#textDiaDr').css("background","#E0E0E0")

			$('#textICDDr').attr('readonly',true);
			$('#textICDDr').css("background","#E0E0E0")

			$('#textICDCode2').attr('readonly',true);
			$('#textICDCode2').css("background","#E0E0E0");

			$('#same_grid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetICDList",
				icd:SDSStr.split("^")[7],
				result:SDSStr.split("^")[8],
				termid:SDSStr.split("^")[3]
			}); 

		}
        $("#same_grid").datagrid('unselectAll');

    },1000) 
    //提交保存
    $('#commitallbtn').click(function(e){
		
        //MKBDRDiagDr^MKBDRDiag^MKBDRMRADMDR^MKBDRTermDR^MKBDRStructResultID^MKBDRSupplement^MKBDRMRCDr^MKBDRICDDesc^MKBDRReson^MKBDRNote^MKBDRStatus 
		var diaDr = $('#push_dia_id').val();
        var dia =   $('#textDiaDr').val();
        var adm =  $('#push_adm_id').val();
		var termdr = $('#result_term_id').val();
        var result = $('#result_Ids').val();
        var Supplement = $('#result_supplement').val();
		var icddr = $('#textICDCode2').val();
		//alert($('#textICDCode2').val())
        var icddesc = $('#textICDDr').val();
       // var reson = $('#justreason_id').text();
        var note = $('#note_str').val();
		//var MKBSDResons=$('#reason_grid').datagrid('getChecked')
		var reson=""
		/*if(MKBSDResons!=""){
			for(var i = 0;i<MKBSDResons.length;i++){
				if(i==0){
					reson = MKBSDResons[i].id;
				}else{
					reson = reson+","+MKBSDResons[i].id;
				}
				
			}
		}*/
		$('.reason').each(function() {
			if($(this).checkbox('getValue')){
				if(reson == ""){
					reson = $(this).val()
				}else{
					reson = reson+","+$(this).val()
				}
			}
		});
        var adm =  $('#push_adm_id').val();
		var icddesc = $('#textICDDr').val();
		var otherdesc = $('#textOtherDesc').val();
		if(dia == "" && termdr == ""  && icddesc == ""){
            $.messager.alert('提示','诊断短语，ICD，结构化诊断至少有一项不能为空!',"error");
            return;
		}
		/*var flag = tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","SameValidate",dia,icddesc,result)
		if(flag>0){
            $.messager.alert('提示','已存在相同的上报数据!',"error");
            return;
		}*/
        var alldata = diaDr +"^"+ dia +"^"+ adm +"^"+ termdr +"^"+ result +"^"+ Supplement +"^"+ icddr +"^"+ icddesc +"^"+ reson +"^"+ note +"^N"+"^"+otherdesc+"^"+pageType
		//alert(alldata)
		var result = tkMakeServerCall("web.DHCBL.MKB.MKBDataReviewed","SaveReviewedDia","",alldata);
		var data=eval('('+result+')');
		if(data.success=='true'){
			parent.$('#myWinDataReviewed').dialog('close')
			parent.$.messager.popover({msg: '上报成功!',type:'success',timeout: 1000});
			
		}else{
			var errorMsg="上报失败！";
			if(data.info){
				errorMsg=errorMsg+'</br>错误信息:'+data.info
			}
			$.messager.alert('错误提示',errorMsg,'error')			
		}

		parent.RefreshData();
	})
	/*****************************************相似诊断开始************************************************************** */
	var samecolumns =[[
		{field:'Rowid',title:'rowid',sortable:true,width:100,hidden:true},
        {field:'MKBSDDiag',title:'<font color=red >类似</font>诊断',sortable:true,width:90,
            formatter:function(value,row,index){
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            }
		},
		{field:'MKBSDMDr',title:'icddr',sortable:true,width:100,hidden:true},
		{field:'MKBSDMrc',title:'ICD描述',sortable:true,width:45},
		{field:'MKBSDICD',title:'ICD编码',sortable:true,width:45},
        {field:'MKBSDResultID',title:'结构化结果id',sortable:true,width:80,hidden:true},
        {field:'Result',title:'结构化结果',sortable:true,width:100,
            formatter:function(value,row,index){
                var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
                return content;
            }
		}, 
		{field:'MKBSDSupplement',title:'补充诊断',sortable:true,width:100,hidden:true},       
		{field:'MKBSDResultTermdr',title:'termdr',sortable:true,width:200,hidden:true}
    ]];
    var diagrid = $HUI.datagrid("#same_grid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBDataReviewed",
			QueryName:"GetSDList"
        },
        columns: samecolumns,  //列信息
        pagination: false,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        //pageSize:PageSizeMain,
        //pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
		checkOnSelect:false,
        selectOnCheck:false,
        remoteSort:false,
        ClassTableName:'User.MKBStructuredData',
        SQLTableName:'MKB_StructuredData',
        idField:'Rowid',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, 
		onDblClickRow:function(rowIndex, rowData)
        {   
		},
		onDblClickCell:function(rowIndex,field,row){
			var rowData = $(this).datagrid('getSelected')
			if(field == "MKBSDICD" || field == "MKBSDMrc"){//icd
				$('#result_icd_id').val(rowData.MKBSDMDr);
				$('#textICDCode2').val(rowData.MKBSDICD)
				$('#textICDDr').val(rowData.MKBSDMrc)
			}else if(field == "MKBSDDiag"){//诊断名
				$('#result_dia_id').val(rowData.MKBSDRowid);
				$('#textDiaDr').val(rowData.MKBSDDiag);  	
			}else if(field == "Result"){//结构化
				$('#result_Ids').val(rowData.MKBSDResultID)
				$('#result_term_id').val(rowData.MKBSDResultTermdr)
				$('#result_supplement').val(rowData.MKBSDSupplement)
				$('#textResult2').val(rowData.Result)
			}
		},
        onRowContextMenu:function (e, rowIndex,row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).datagrid('selectRow', rowIndex);
            var mygridmmm = $('<div style="width:150px;"></div>').appendTo('body');
            $(
				'<div onclick="reviewedAll()" iconCls="icon-copyorder" data-options="">选中整条数据</div>'
            ).appendTo(mygridmmm)
            mygridmmm.menu()
            mygridmmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        }	

	});
	//选中整条
	reviewedAll = function(){
		var rowData = $('#same_grid').datagrid('getSelected');
		$('#result_dia_id').val(rowData.MKBSDRowid);
		$('#textDiaDr').val(rowData.MKBSDDiag);    
		
		$('#result_icd_id').val(rowData.MKBSDMDr);
		$('#textICDCode2').val(rowData.MKBSDICD)
		$('#textICDDr').val(rowData.MKBSDMrc)

		$('#result_Ids').val(rowData.MKBSDResultID)
		$('#result_term_id').val(rowData.MKBSDResultTermdr)
		$('#result_supplement').val(rowData.MKBSDSupplement)
		$('#textResult2').val(rowData.Result)		
	}
	//alert(parent.STBBase)
	//每次做完修改操作，刷新列表
	refreshSameGrid = function(){
		var diag = $('#textDiaDr').val();
		var icd = $('#textICDDr').val();
		var result = $('#textResult2').val();
		if(pageType == "SD"){
			$('#same_grid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetSDList",
				//base:STBBase,
				diag:diag,
				icd:icd,
				result:result,
				termid:$('#result_term_id').val(),
				icdcode:$('#textICDCode2').val(),
				icdcode:$('#textICDCode2').val()
				

			}); 
	
		}else{
			$('#same_grid').datagrid('load',  { 
				ClassName:"web.DHCBL.MKB.MKBDataReviewed",
				QueryName:"GetICDList",
				icd:icd,
				result:result,
				termid:$('#result_term_id').val()
			}); 
	
		}
        $("#same_grid").datagrid('unselectAll');
	}
	/*****************************************相似诊断结束************************************************************** */

    /*****************************************相似诊断上方的上报表格开始************************************************* */
    var columns =[[
        {field:'no',title:'',sortable:true,width:20,
            styler:function(value,row,index){
                return 'background-color:#F4F6F5;'; //和表头一致的背景色
            }
        },
        {field:'Diag',title:'诊断短语',sortable:true,width:70},
        {field:'ICDDesc',title:'ICD描述',sortable:true,width:70},
        {field:'ICDNumber',title:'ICD编码',sortable:true,width:40},
        {field:'DiagExp',title:'诊断表达式',sortable:true,width:70}
        //{field:'OtherDesc',title:'其他描述',sortable:true,width:40},
    ]];

    var table = $HUI.datagrid("#reviewed_grid",{     
        data:[
            {no:'原始',Diag:'<font color=red id="textDia"></font>',ICDDesc:'<font color=red id="textICDDesc"></font>',ICDNumber:'<font color=red id="textICDCode"></font>',DiagExp:'<font color=red id="textResult"></font>'},
            {no:'目标',Diag:'<input id="textDiaDr" type="text"  style="width:270px" class="hisui-validatebox">',ICDDesc:'<input id="textICDDr" onclick="ICDWin(1)" type="text"  class="hisui-validatebox" style="width:270px" readonly="true">',ICDNumber:'<input id="textICDCode2" onclick="ICDWin(2)" type="text" class="hisui-validatebox"  style="width:148px" readonly="true">',DiagExp:'<input id="textResult2" onclick="propertyListWin()" type="text"  class="hisui-validatebox" style="width:270px" readonly="true">'},//OtherDesc:'<input id="textOtherDesc" type="text"  class="hisui-validatebox" style="width:150px">'},
            {no:'<table style="border:0px"><td style="border:0px;">备注</td>'+'<td style="border:0px;"><input id="note_str" type="text" class="hisui-validatebox" style="height:25px;width:1100px;margin-left:52px;margin-top:0px;padding:0px"></td></table>'},
            {no:'<table><td style="border:0px;">上报理由</td>'+
            '<td style="border:0px;padding-left:25px">缺诊断短语</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox" data-options="checked:false" style="margin-top:5px" value="A" id="reason_A"></td>'+
            '<td style="border:0px;padding-left:10px">缺ICD</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox" data-options="checked:false" style="margin-top:5px" value="E" id="reason_E"></td>'+
            '<td style="border:0px;padding-left:10px">缺诊断表达式</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox" data-options="checked:false" style="margin-top:5px" value="C" id="reason_C"></td>'+
            '<td style="border:0px;padding-left:10px">诊断短语不正确</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox" data-options="checked:false" style="margin-top:5px" value="B" id="reason_B"></td>'+
            '<td style="border:0px;padding-left:10px">ICD不正确</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox"  data-options="checked:false" style="margin-top:5px" value="F" id="reason_F"></td>'+
            '<td style="border:0px;padding-left:10px">诊断表达式不正确</td><td style="border:0px;"><input class="hisui-checkbox reason" type="checkbox"  data-options="checked:false" style="margin-top:5px" value="D" id="reason_D"></td>'+
            '</table>'
            }
        ],
        columns: columns,  //列信息
        pagination: false,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        //pageSize:PageSizeMain,
        //pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        checkOnSelect:false,
        selectOnCheck:false,
        remoteSort:false,
        ClassTableName:'User.MKBStructuredData',
        SQLTableName:'MKB_StructuredData',
        idField:'no',
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true,
        onLoadSuccess: function (data) {
            var merges_a = [{
                index: 2,//合并第5行的列,从0开始，所以index=4是第五行。
                colspan: 5//合并列的数量
            },{
                index: 3,//合并第5行的列,从0开始，所以index=4是第五行。
                colspan: 5//合并列的数量
            }];
            for (var i = 0; i < merges_a.length; i++)
            {
                //alert(merges_a.length);
                $('#reviewed_grid').datagrid('mergeCells', {
                    index: merges_a[i].index,
                    field: 'no',//合并后单元格对应的属性值
                    colspan: merges_a[i].colspan
                });
            }             
        },
        onClickCell:function(rowIndex, field, value){
        }
    });

    
    /*****************************************相似诊断上方的上报表格结束************************************************* */
}
$(init);