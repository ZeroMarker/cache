var GV={}
GV.proxy = "web.DHCENS.STBLL.Method.SystemStatusConfigMvc.cls?";
function commonAjax(url, params, ansycflag, fn) {
    var reData = '', postUrl = url;
    if (typeof arguments[arguments.length - 1] === "function")
        var callbackftn = arguments[arguments.length - 1];

    if (ansycflag == null) {
        var ansycflag = true;
    } else {
        var ansycflag = false;
    }

    if (typeof params === "object") {
        paradata = params
    } else {
        $.error("入参格式不对:" + params)
    }
    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        data: paradata,
        async: ansycflag,
        success: function (data) {
            if (callbackftn != undefined || callbackftn != null && typeof callbackftn === "function") {
                callbackftn(data);
            } else {
                reData = data;
                return reData;
            }
            ;
        },
        error: function (a, b, c) {
            var errorstr = "错误日志：" + "\n"
                + "url：" + url + ";" + "\n"
                + "params: " + JSON.stringify(params) + ";" + "\n"
                + "reason:" + JSON.stringify(a) + "\n";
            +b + "\n";
            +c + "\n";
            try {
                console.error("ajax错误：", errorstr, JSON.stringify(a), b, c)
                //console.error(errorstr)
            } catch (e) {
                alert(errorstr);
            }

        }
    });
    return reData;

}





function loadTable() {
    GV.tb = $HUI.datagrid('#mtSourceTb', {
	    fit:true,
        headerCls: 'panel-header-gray',
        //rownumbers: true,
        singleSelect: true,
        pagination: true,
        fixRowNumber: true,
       // title: '医技系统来源字典表',
        idField: 'id',
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100],
        afterPageText: '页,共{pages}页', beforePageText: '第', displayMsg: '显示{from}到{to}条，共{total}条',
        fitColumns: true,
        url: GV.proxy + "action=GetEnsSystem&Input=",
        // url:$URL+"drms.Dao.DRUser/GetUserInfoData?rows=9999&Input=",
        /*queryParams:{
                Input:"0^100"
        },*/
        columns: [[       
            {field: 'cfgSysCode', title: '系统代码'},
            {field: 'cfgSysDesc', title: '系统描述'},
            {field: 'cfgSysVersion', title: '版本'},
            {field: 'cfgcourtyard', title: '院区',
            	formatter: function(value, row, index) { 
            		GV.courtyard.forEach(function(item){
                  if(item.code==value){
                    return item.desc
                  }
                })
            	}
            },
            {field: 'cfgSysModel', title: '模式',
            	formatter: function(value, row, index) { 
            		var str=value=='Y'? "共库":"分库"
                return str
            	}
            },
            {field: 'cfgProduction', title: '产品组',
            	formatter: function(value, row, index) { 
            		GV.productList.forEach(function(item){
                  if(item.code==value){
                    return item.desc
                  }
                })
            	}
            },
            {field: 'cfgStatus', title: '状态',
            	formatter: function(value, row, index) { 
                var val=value=="Y"?true:false
                var dataoptions="onText:'启用',offText:'停用',size:'small',animated:true,onClass:'primary',offClass:'gray',checked:"+val
                var str='<div class="hisui-switchbox" data-options="'+dataoptions+'"></div>'
            		return str
            	}
            },
           

        ]],
        toolbar:'#toolbar',
       
    });
  
}
//初始化模态框
function modalInit() {
  //初始化 新增|编辑 模态框
  $('#addOrEditDiag').dialog({
    title: '新增',
    width: 400,
    height: 200,
    iconCls:'icon-add',
    modal:true,
    closed:true,
    buttons:[{
      text:'保存',
      handler: function () {
       
        if ($(".window-header .panel-title").text() == "新增") { // 新增
          // 获取表单数据
          var input =JSON.stringify( $("#configForm").serializeArray()) 
          $.ajax({ 
            type: "POST",
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "web.DHCENS.SGV.STBLL.UTIL.PageLoad.cls?action=baseDataConfigAdd&input="+input,
            dateType: "json",
            success: function(rs){
              if(rs.data=="1"){
                $('#addOrEditDiag').dialog('close');
                GV.tb.reload()
              }else{
                $.messager.alert("错误",rs.data);
              }  
            }
          })  
        }else{//更新
          // 获取表单数据
          var input =JSON.stringify( $("#configForm").serializeArray()) 
          $.ajax({ 
            type: "POST",
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            url: "web.DHCENS.STBLL.UTIL.PageLoad.cls?action=baseDataConfigUpdate&input="+input,
            dateType: "json",
            success: function(rs){
              if(rs.data=="1"){
                $('#addOrEditDiag').dialog('close');
                GV.tb.reload()
              }else{
                $.messager.alert("错误",rs.data);
              }  
            }
          })  
        }
      }
    },{
      text: '关闭',
      handler: function () {
          $('#addOrEditDiag').dialog('close');
      }
    }
  ]
  });

  //获取 [所属产品组] 产品组数据
  GV.productList=commonAjax(GV.proxy, {
    action: "GetproductData",
    input:"enable"
    }, "", "")
  $("#cfgProduction").combobox({
    valueField:'code',
    textField:'desc',
    data:GV.productList.rows
    // method:'get',
    // url:'web.DHCENS.STBLL.UTIL.PageLoad.cls?action=methodProcuctionTermlist'
  })

  // 初始化 [所属院区]
  GV.courtyard=commonAjax(GV.proxy, {
    action: "GetCourtyarData",
    input:"enable"
    }, "", "")
    // 初始化院区
  $("#courtyard").combobox({
    valueField:'code',
    textField:'desc',
    data:GV.courtyard.rows
  })
  // 初始化院区-新增|编辑
  $("#cfgcourtyard").combobox({
    valueField:'code',
    textField:'desc',
    data:courtyard.rows
  })


  //初始化导入模态框
  $('#importDiag').dialog({
    title: '导入',
    width: 400,
    height: 200,
    iconCls:'icon-upload',
    modal:true,
    closed:true,
    buttons:[{
      text:'导入',
      handler: function () {
       //导入数据
        //获取当前选中的模板ID
        var tabId = "config"
        $('#Pbar').parent().show();
        $('#Pbar').progressbar('setValue',10);
        $(this).linkbutton('disable');
        //文件名
        var files=$('#selectFile').filebox('files');
        if(files && files.length>0){
          //读取文件
          ImportFiles(files,tabId);
          // ImportFiles(files);
        }else{
          $.messager.alert("提示","请选择至少一个Excel文件！","warning");
        }
      }
    },{
      text: '关闭',
      handler: function () {
          $('#importDiag').dialog('close');
      }
    }],
    onBeforeClose:function(){
			$('#PbarTip').text("正在导入,请稍后...")
			$('#Pbar').parent().hide();
			$('#Pbar').progressbar('setValue',10);
			$('#file').filebox('clear');
		},
  });

}


//查询
function cfgSearch(){
  // 获取查询参数
  var sysDesc=$("#sysDesc").val()
  var courtyard=$("#courtyard").combobox('getValue')
  var model=$("#model").combobox('getValue')
  var status=$("#status").switchbox('getValue')
 
  var input=sysDesc+"^"+courtyard+"^"+model+"^"+status
  GV.tb.reload({input:input})

}

// 新增
function cfgAdd(){
  $('#addOrEditDiag').dialog({
    iconCls: 'icon-add',
    title: '新增',
  }).dialog('open');
  $("#configForm")[0].reset()
}
// 编辑
function cfgUpdate(){
  var row = GV.tb.getSelected();
  if (row) {
    $('#addOrEditDiag').dialog({
        iconCls: 'icon-edit',
        title: '编辑',
    }).dialog('open');
    //赋值   
    $("#cfgSysCode").val(row.cfgSysCode)
    $("#cfgSysDesc").val(row.cfgSysDesc)
    $("#cfgSysVersion").val(row.cfgSysVersion)
    $("#cfgcourtyard").combobox('setValue',row.cfgcourtyard);
    $("#cfgSysModel").combobox('setValue',row.cfgSysModel);
    $("#cfgProduction").combobox('setValue',row.cfgProduction);
    $("#cfgStatus").combobox('setValue',row.cfgStatus);
  } else {
      $.messager.alert("错误", "请选择行");
  }
}

// 刷新
function cfgReload(){
  GV.tb.reload();
}

// 导入
function cfgImport(){
  $('#importDiag').dialog('open')

}
// 表ID_表名_其他
function ImportFiles(file,tabId){
  var fileSize=file[0]["size"]; //文件数据长度（控制文件大小）
  var fileLength=file.length; //文件个数（多个上传时使用）
  var fileName=file[0]["name"]; //文件名
  var fileNameArr=fileName.split("_");
  var fileCode=fileNameArr[0]; //文件代码(表代码)
  var fileDesc=fileNameArr[1].split(".")[0]; //文件描述（表描述）
  var filetype=fileNameArr[1].split(".")[1]; //文件类型（）
  if((fileCode==tabId)&&(fileSize!=0)){
    var f = file[0]; 
    //读取Excel文件
    ImportFileExcel(f,tabId);
  }else{
    $('#Pbar').progressbar('setValue',0);
    $('#PbarTip').text("导入失败...");
    if(fileCode!=tabId){$.messager.alert("提示","表代码("+fileCode+")与模板("+tabId+")不符，请确认","warning")}
    if(fileSize==0){$.messager.alert("提示","导入的文件数据为空","warning")}
    
  }	
 
}


/*********************************************读取Excel数据-S*******************/
//导入Excel
/*针对所有浏览器的导入excel相关函数*/
var wb;
var detailjson={};
//读取完成的数据
var rABS = false; 
//是否将文件读取为二进制字符串
ImportFileExcel=function(f,tabId) {
 ///获取excel中的数据
 var reader = new FileReader();
 ///因为IE浏览器不识别readAsBinaryString函数，所以重新书写readAsBinaryString函数
 if (!FileReader.prototype.readAsBinaryString) {
     FileReader.prototype.readAsBinaryString = function (f) {
     var binary = "";
          var pt = this;
          var reader = new FileReader();      
          reader.onload = function (e) {
       var bytes = new Uint8Array(reader.result);
              var length = bytes.byteLength;
              for (var i = 0; i < length; i++) {
                  binary += String.fromCharCode(bytes[i]);
              }
         pt.content = binary;
         var datastr=$(pt).trigger('onload');
     }
     reader.readAsArrayBuffer(f);
     }
 }
  
 reader.onload = function(e) {
   if (reader.result) reader.content = reader.result;
     var data = reader.content;      
     if(rABS) {
           wb = XLSX.read(btoa(fixdata(data)), {//手动转化
           type: 'base64'
       });
     } else {
         wb = XLSX.read(data, {
             type: 'binary'
         });
     }
     detailjson= XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]) ;
     console.log("detailjson",detailjson)
     //插入数据
     ImportData(detailjson,tabId);
     //return detailjson;
 };

 if(rABS) {
     reader.readAsArrayBuffer(f);
 } else {
     reader.readAsBinaryString(f);

 }
}

function fixdata(data) { //文件流转BinaryString
 var o = "",
     l = 0,
     w = 10240;
 for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
 o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
 return o;
}

/*******************************读取Excel数据-E*********************************/
//插入数据
ImportData=function(jsonData,tabId){
 var jsonDataLength=jsonData.length;
 var jsonDataObj=jsonData[0];
 for(var i=1;i<jsonDataLength;i++){
   for(j in jsonDataObj){
     jsonDataObj[j]=jsonDataObj[j]+"^"+jsonData[i][j];
   }
 }
 jsonDataObj["tabId"]=tabId; //报表ID
 jsonDataObj["createUserCode"]=userName; //用户代码
 var jsonStr=JSON.stringify(jsonDataObj);
 //插入数据	
 $.post($URL+"drms.Entity.Method.DRReportDataDetail/ImportData",{Input:jsonStr},null,'text').done(function(rtn){
   if(rtn==1){
     $('#Pbar').progressbar('setValue',100);
     $('#PbarTip').text("导入成功！");
     GV.tg.reload();
   }else{
     $('#Pbar').progressbar('setValue',0);
     $('#PbarTip').text("导入失败！");
     //关闭模态框
     $("#import").dialog("close");
     GV.tg.reload();
   }
 });
}




$(function () {
    loadTable()
    modalInit()
})