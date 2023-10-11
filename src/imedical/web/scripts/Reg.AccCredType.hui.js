var PageLogicObj={
	m_Grid:"",
	m_RowId:"",
	m_ClassName:"web.UDHCAccCredType"
}
$(function(){
	//初始化
	Init()
	//事件初始化
	InitEvent()
	//注册配置加载数据
	DataListLoad();
	InitCache();
})

function Init(){
	//初始化界面上ComboBox
	InitComboBox()
	InitDataGrid()
}
function InitEvent(){
	//定义新增按钮事件
	$("#Add").bind("click",AddClick)
	$("#Update").bind("click",UpdateClick)
	$("#Delete").bind("click",DeleteClick)
	$("#translate").bind("click",translateClick)
	$("#acccredSort").bind("click",SortBtn)
	$("#acccredSortPlan").bind("click",SetDefConfig)
	InitSortType();
	$("#SaveConfig").bind("click",SaveConfigClick)
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function InitDataGrid(){
	//,:%String,DefualtProvince:%String,:%String,:%String,:%String,:%String
	var Columns=[[    
        { field : 'TCredTypeID',title : '',width : 1,hidden:true},
		{ field: 'TCredCode', title: '证件名称',  width:100,sortable: true, resizable: true},
		{ field : 'TCredDesc',title : '证件描述', width:200,sortable: true, resizable: true},
        { field : 'TSureFlag',title : '默认', width:130,sortable: true, resizable: true,
        	formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
        },
		{ field : 'TActive',title : '激活', width:130,sortable: true, resizable: true,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		},
		{ field : 'TDateFrom',title : '开始日期', width:200,sortable: true, resizable: true},
		{ field : 'TDateTo',title : '结束日期', width:200,sortable: true, resizable: true},
		{ field : 'TCredNoRequired',title : '证件号不允许为空', width:130,sortable: true, resizable: true,
			formatter:function(value,row,index){
				if (value == "Y") {
					return "<span class='c-ok'>是</span>"
				} else {
					return "<span class='c-no'>否</span>"
				}
			}
		}
	]];
	/**
 	 * FIXED QP
 	 * 如果使用原生的，表头将会错乱，改为$HUI.datagrid
 	 */
	PageLogicObj.m_Grid = $HUI.datagrid("#DataList", {
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		remoteSort:false,
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		onSelect:function(index,rowData){
			PageLogicObj.m_RowId=rowData["TCredTypeID"]
			DataGridSelect(rowData["TCredTypeID"])
		},
		onUnselect:function(){
			PageLogicObj.m_RowId="";
			DataGridUnSelect();
		},
		onBeforeSelect:function(index, row){
			var selrow=$("#DataList").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#DataList").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#DataList").datagrid('unselectRow',index);
					return false;
				}
			}
		}
	
	});
	/*
	var dataGrid=$("#DataList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'RowID',
		columns :Columns,
		onSelect:function(index,rowData){
			PageLogicObj.m_RowId=rowData["TCredTypeID"]
			DataGridSelect(rowData["TCredTypeID"])
		},
		onUnselect:function(){
			PageLogicObj.m_RowId="";
			DataGridUnSelect();
		},
		onBeforeSelect:function(index, row){
			var selrow=$("#DataList").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#DataList").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#DataList").datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});*/
	//dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	PageLogicObj.m_Grid.loadData({ 'total':'0',rows:[] });
	//return dataGrid;
}
function DataListLoad(){
	$.cm({
	    ClassName : "web.UDHCAccCredType",
	    QueryName : "FindCredType",
	    rows:99999
	},function(GridData){
		//$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//$("#DataList").datagrid("clearSelections")
		PageLogicObj.m_Grid.loadData(GridData);
		PageLogicObj.m_Grid.clearSelections();
	});
}
function InitComboBox(){
	///初始化 设备类型 
	$.cm({
			ClassName:"web.DHCBL.UDHCCommFunLibary",
			QueryName:"InitListObjectValueNew",
			ClassName1:"User.DHCCardHardComGroup",
			PropertyName:"CCGType",
			rows:99999
		},function(GridData){
			var cbox = $HUI.combobox("#Type", {
					valueField: 'ValueList',
					textField: 'DisplayValue', 
					editable:true,
					data: GridData["rows"]
			 });
	});
}
function SaveData(RowId){
	if(!CheckData()) return 
	var dataJson={}
	$.each(FieldJson,function(name,value){
		var val=getValue(value)
		val='"'+val+'"'
		eval("dataJson."+name+"="+val)
	});
	var jsonStr=JSON.stringify(dataJson)
	$m({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"SaveByJson",
		RowId:RowId,
		JsonStr:jsonStr
	},function(txtData){
		if(txtData==0){
			if(RowId==""){
				$.messager.popover({msg: '新增成功！',type:'success',timeout: 1000});
			}else{
				$.messager.popover({msg: '更新成功！',type:'success',timeout: 1000});
				PageLogicObj.m_RowId="";
			}
			DataListLoad()
			clear()
		}else{
			if(txtData=="DateErr"){
				$.messager.alert("提示", "开始日期不能大于结束日期.", 'info');
			}else if(txtData=="-316"){
				$.messager.alert("提示", "证件名称重复!", 'info');
			}else if(txtData=="-317"){
				$.messager.alert("提示", "证件描述重复!", 'info');
			}else if(txtData=="DEF"){
				$.messager.alert("提示", "已经有默认类型不能再置默认.", 'info');
			}
		}
	});
}
function CheckData(){
	var Code=$("#Code").val()
	if(Code==""){
		$.messager.alert("提示", "证件类型名称不能为空", 'info');
		return false 
	}
	var Desc=$("#Desc").val()
	if(Desc==""){
		$.messager.alert("提示", "证件类型描述不能为空", 'info');
		return false 
	}
	return true
}
function AddClick(){
	SaveData("")
}
function UpdateClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择证件类型数据", 'info');
		return 
	}
	SaveData(PageLogicObj.m_RowId)
}
function DeleteClick(){
	if(PageLogicObj.m_RowId==""){
		$.messager.alert("提示", "请选择要删除的设备类型", 'info');
		return 
	}
	$m({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"Delete",
		rowid:PageLogicObj.m_RowId
	},function(txtData){
		if(txtData==0){
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			DataListLoad()
			clear()
			PageLogicObj.m_RowId=""
		}
	});
}
function DataGridSelect(RowId){
	$.cm({
		ClassName:PageLogicObj.m_ClassName,
		MethodName:"GetDataJson",
		RowId:RowId,
		jsonFiledStr:JSON.stringify(FieldJson)
	},function(JsonData){
		if(JsonData!=""){
			$.each(JsonData,function(name,value){
				setValue(name,value)
			})
		}
	});
}
function DataGridUnSelect(){
	$("#Code,#Desc").val('');
	$("#DateFrom,#DateTo").datebox('setValue','');
	$("#Default,#Active").switchbox('setValue',true);
}
///根据元素的classname获取元素值
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-switchbox")>=0){
		var val=$("#"+id).switchbox("getValue")
		return val=(val?'Y':'N')
	}else if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//如果放大镜文本框的值为空,则返回空值
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		return $("#"+id).combobox("getValue")
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
///给元素赋值
function setValue(id,val){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		$("#"+id).val(val)
		return 
	}
	if(className.indexOf("hisui-switchbox")>=0){
		val=(val=="Y"?true:false)
		$("#"+id).switchbox("setValue",val)
	}else if(className.indexOf("hisui-combobox")>=0){
		$("#"+id).combobox("setValue",val)
	}else if(className.indexOf("hisui-datebox")>=0){
		$("#"+id).datebox("setValue",val)
	}else{
		$("#"+id).val(val)
	}
	return ""
}
///编辑窗口清屏
function clear(){
	$.each(FieldJson,function(name,value){
		setValue(value,"")
	})
}
//界面元素和表里字段对照 
var FieldJson={
	CRTCode:"Code",
	CRTDesc:"Desc",
	CRTdefault:"Default",
	CRTActive:"Active",
	CRTDateFrom:"DateFrom",
	CRTDateTo:"DateTo",
	CRTCredNoRequired:"CredNoRequired"
}

function translateClick(){
	 var SelectedRow =  $HUI.datagrid("#DataList").getSelected()
	if (!SelectedRow){
	$.messager.alert("提示","请选择需要翻译的行!","info");
	return false;
	}
	CreatTranLate("User.DHCCredType","CRTDesc",SelectedRow["TCredDesc"])
	}
function InitFunLib(usertableName){
	var HospID=session['LOGON.HOSPID'];
	var indexs="";var sortstr="";
	var sortWin='<div id="sortWin" style="width:570px;height:450px;"></div>';
	var sortGrid='<table id="sortGrid"></table>';
	$('body').append(sortWin);
	$('#sortWin').append(sortGrid);
	  var columns=[[
	    {field:'SortId',title:'SortId',hidden:true},
	    {field:'RowId',title:'对应表RowId',hidden:true},
	    {field:'Desc',title:'描述',width:180},
	    {field:'SortType',title:'排序类型',hidden:true},
	    {field:'SortNum',title:'顺序号',editor:{'type':'numberbox'},width:180}
	  ]];
  var sortGrid=$HUI.datagrid('#sortGrid',{
      url: $URL,
      queryParams:{
        ClassName:"web.DHCBL.BDP.BDPSort",
        QueryName:"GetList",
        'tableName':usertableName,
        'hospid':""
      },
      columns: columns,  //列信息
      pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
      pageSize:20,
      pageList:[5,10,14,15,20,25,30,50,75,100,200,300,500,1000],
      singleSelect:true,
      idField:'SortId',
      fit:true,
      rownumbers:true,    //设置为 true，则显示带有行号的列。
      fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
      //remoteSort:false,  //定义是否从服务器排序数据。定义是否从服务器排序数据。true
      //toolbar:'#mytbar'
      toolbar:[],
      onClickCell:function(index, field, value){
        if(indexs!==""){
           $(this).datagrid('endEdit', indexs);
        }
        $(this).datagrid('beginEdit', index);
        indexs=index;
      },
      onAfterEdit:function(index, row, changes){
        var type=$HUI.combobox('#TextSort').getText();
        if(JSON.stringify(changes)!="{}"){
          if(sortstr!==""){
            sortstr=sortstr+'*'+usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }else{
            sortstr=usertableName+'^'+row.RowId+'^'+type+'^'+row.SortNum+'^'+row.SortId;
          }
        }
      },
      onClickRow:function(index,row){
      },
      onDblClickRow:function(index, row){
      }
  });
  var toolbardiv='<div id="Sortb">排序类型&nbsp;<input id="TextSort" style="width:207px"></input><a plain="true" id="SortRefreshBtn" >重置</a><a plain="true" id="SortSaveBtn" >保存</a><a plain="true" id="SortUpBtn" >升序</a><a plain="true" id="SortLowBtn" >降序</a></div>';

  $('#sortWin .datagrid-toolbar tr').append(toolbardiv);
  $('#SortRefreshBtn').linkbutton({
      iconCls: 'icon-reload'
  });
  $('#SortSaveBtn').linkbutton({
      iconCls: 'icon-save'
  });
  $('#SortUpBtn').linkbutton({
      iconCls: 'icon-arrow-top'
  });
  $('#SortLowBtn').linkbutton({
      iconCls: 'icon-arrow-bottom'
  });
  $('#SortRefreshBtn').click(function(event) {
    //$('#TextSort').combobox('reload');
    $HUI.combobox('#TextSort').reload();
    $HUI.combobox('#TextSort').setValue();
    GridLoad(usertableName,'','');


  });

  $('#SortUpBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'ASC')
  });
  $('#SortLowBtn').click(function(event) {
    var type=$HUI.combobox('#TextSort').getText();
    GridLoad(usertableName,type,'DESC')
  });
  $('#SortSaveBtn').click(function(event){
    var type=$HUI.combobox('#TextSort').getText();
    if(type==""){
      $.messager.alert('提示','排序类型不能为空！','error');
      return
    }
    if(indexs!=""){
      $('#sortGrid').datagrid('endEdit', indexs);
    }
    /*if(sortstr==""){
      $.messager.alert('提示','没有修改排序顺序号数据无需保存！','error');
      return
    }*/
    var NewSortArr=new Array();
	for (var i=0;i<sortstr.split("*").length;i++){
		var onesort=sortstr.split("*")[i];
		var onesortArr=onesort.split("^");
		onesortArr[2]=type;
		NewSortArr.push(onesortArr.join("^"));
	}
	sortstr=NewSortArr.join("*");
    $.ajax({
      url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPSort&pClassMethod=SaveData",
      data:{
            "sortstr":sortstr,
            MWToken:('undefined'!==typeof websys_getMWToken)?websys_getMWToken():""
      },
      type:'POST',
      success:function(data){
        var data=eval('('+data+')');
        if(data.success=='true'){
            $.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
         
          var types=$HUI.combobox('#TextSort').getText();
          GridLoad(usertableName,types,'')
          //$HUI.combobox('#TextSort').reload();
        }
        else{
          var errorMsg="修改失败！";
          if(data.errorinfo){
            errorMsg=errorMsg+'</br>错误信息:'+data.errorinfo
          }
          $.messager.alert('错误提示',errorMsg,'error')
        }
      }
    });
  });
  
};
function SortBtn(){
	var usertableName="User.DHCCredType"
	 InitFunLib(usertableName)
	var Sortwin=$HUI.dialog('#sortWin',{
	  iconCls:'icon-w-list',
	  resizeable:true,
	  title:'排序(排序类型可手动录入)',
	  modal:true,
	  onClose:function(){
		  InitSortType();
	  }
	});
	GridLoad(usertableName,'','');
	$('#TextSort').combobox({
	  url:$URL+"?ClassName=web.DHCBL.BDP.BDPSort&QueryName=GetDataForCmb1&ResultSetType=array",
	  valueField:'SortType',
	  textField:'SortType',
	  onBeforeLoad:function(param){
	    param.tableName=usertableName;
	    param.hospid="";
	  },
	  onLoadSuccess:function(){
	  },
	  onSelect:function(record){
	    var type=record.SortType;
	    GridLoad(usertableName,type,'')
	  }
	});
};
function GridLoad (usertableName,type,dir){
	var HospID=session['LOGON.HOSPID'];
    sortstr="";
    $('#sortGrid').datagrid('load',{
      ClassName:"web.DHCBL.BDP.BDPSort",
      QueryName:"GetList",
      'tableName':usertableName,
      'type':type,
      'dir':dir,
      'hospid':""
    });
    $('#sortGrid').datagrid('unselectAll');
  };
var SortTypeData="";
function InitSortType(){
	$.q({
		ClassName:"web.DHCBL.BDP.BDPSort",
		QueryName:"GetDataForCmb1",
		rowid:"",desc:"",
		tableName:"User.DHCCredType",hospid:"",
		dataType:"json"
	},function(Data){
		SortTypeData=Data.rows;
		$("#acccredtypeSort").combobox({
			textField:"SortType",
			valueField:"ID",
			data:Data.rows,
			OnChange:function(newValue,OldValue){
				if (!newValue) {
					$(this).combobox('setValue',"");
				}
			}
		})
	})
	}

function SetDefConfig() {
	var Node1="acccredtypeSort"
	var TypeId="acccredtypeSort"
	var HospId=session['LOGON.HOSPID']
	$("#acccredtype-dialog").dialog("open")
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"GetSpecConfigNode",
		NodeName:Node1,
		HospId:HospId,
		dataType:"text"
	},function(rtn) {
		if ($.hisui.indexOfArray($("#"+TypeId).combobox('getData'),"SortType",rtn) >=0) {
			$("#"+TypeId).combobox("setText",rtn);
		}else{
			$("#"+TypeId).combobox("setText","");
		}
	})
	
}
function SaveConfigClick() {
	var acccredtypeSort=$("#acccredtypeSort").combobox("getText");
	if (($.hisui.indexOfArray(SortTypeData,"SortType",acccredtypeSort)<0)&&(acccredtypeSort!="")) {
		$.messager.alert("提示","请选择时段列表排序！","info",function(){
			$("#acccredtypeSort").next('span').find('input').focus();
		});
		return false;
	}
	var SortConfig="acccredtypeSort"+"!"+acccredtypeSort
	SaveConfig(SortConfig)
	
	$.messager.show({title:"提示",msg:"保存成功"});
	$("#acccredtype-dialog").dialog("close")
}
function SaveConfig(SortConfig) {
	var HospId=session['LOGON.HOSPID']
	$.cm({
		ClassName:"web.DHCOPRegConfig",
		MethodName:"SaveConfigHosp",
		Coninfo:SortConfig,
		HospID:HospId
	},false)
}
