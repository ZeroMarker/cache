/// Function: 查看日志功能页面 (单页面查看)
/// Creator:  sunfengchao/chenying
/// CreateDate: 2018-04-04
var init = function(){
  
  function GetRequest() {
     var url = location.search; //获取url中"?"符后的字串   
     var theRequest = new Object();   
     if (url.indexOf("?") != -1) {   
        var str = url.substr(1);   
        strs = str.split("&");   
        for(var i = 0; i < strs.length; i ++) {   
           theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);   
        }   
     }   
     return theRequest;   
  }   
  var classparam= GetRequest().TableName;  
  if (classparam== undefined ){
    classparam="";
   }
  var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList&MKBFlag="+MKBFlag+"&UserClass="+classparam;
  //回车触发查询
    $('#fuzzyserch,#ClassName,#ObjectDesc,#UpdateUserDR').keyup(function (event) {
        if (event.keyCode == 13) {
            SearchFunLib();
        }
    }); 
    $('#checkdatefrom,#checkdateto').datebox({
    onSelect: function(){
      SearchFunLib();
    }
  });
  $HUI.combobox("#OperateTypeD",{
    valueField:'value',
    textField:'text',
    data:[
      {value:'A',text:'添加'},
      {value:'U',text:'修改'},
      {value:'D',text:'删除'}
    ],
    onSelect:function(){
      SearchFunLib();
    }
  });
   
      
    //查询按钮
    $("#btnSearch").click(function (e) { 
         SearchFunLib();
     })  
     
    //重置按钮
    $("#btnRefresh").click(function (e) { 
         ClearFunLib();
     }) 
     
     function Viewlogdetail()
     {
      
        var rows = $("#mygrid").datagrid("getSelected"); 
            if (!(rows))
            {    
              $.messager.alert('错误提示','请先选择一条数据!','error');
                return;
            }
            else{
                var Operation= rows.OperateType;   
                if(Operation=="U"){
                    Operation="修改操作"            
                }
                if(Operation=="A"){
                    Operation="添加操作"            
                }
                if(Operation=="D"){
                    Operation="删除操作"            
                }
       
                var ClassUserName=rows.ClassName; 
                if ((ClassUserName!="User.BDPPreferences")&&(ClassUserName!="User.BDPTableList"))
                {  
                    var link="dhc.bdp.mkb.bdpdatachangelogwin.csp?actiontype=datadetail&id="+rows.ID;
                    if ('undefined'!==typeof websys_getMWToken){
                      link += "&MWToken="+websys_getMWToken()
                    }
                    var content='<iframe id="logdetailwin" src=" '+link+' " width="100%" height="100%"></iframe>'
                    var LookUpWin = $HUI.dialog("#logdetailwin",{
                        resizable:true,
                        title:'日志数据详情',
                        modal:true ,
                        width:1100,
                        height:500,
                        content :content 
                     });  
                    $("#logdetailwin").show(); 
                }
              }
     }
    /// 数据详情
     $('#btnlogdetail').click(function(e){
            Viewlogdetail();
     })
     ///数据生命周期
     $("#btnloglife").click(function (e) { 
         var rows = $("#mygrid").datagrid("getSelected"); 
            if (!(rows))
            {   
              $.messager.alert('错误提示','请先选择一条数据!','error');
                return;
            }
            else{  
              var ClassNameDesc=rows.ClassName;  
              var objrowid=rows.ObjectReference;
              var objdesc= rows.ObjectDesc;
              if (objdesc.indexOf("&")>-1)
              {
                objdesc=objdesc.replace(/\&/g,"$");
              }
              var link="dhc.bdp.timeline.csp?actiontype=timeline&ClassN="+ClassNameDesc  +"&OBJDESC="+objrowid+"&ObjectDesc="+objdesc;
              if ('undefined'!==typeof websys_getMWToken){
                link += "&MWToken="+websys_getMWToken()
              }
              var link=encodeURI(link)
              var content='<iframe id="iframsort" src=" '+link+' " width="100%" height="100%"></iframe>';
              var LookLifeWin = $HUI.dialog("#LookLifeWin",{
                resizable:true,
                title:'查看数据生命周期',
                width:1100,
                height:450,
                modal:true ,
                autoScroll:false,
                content :content 
         });  
       }
     }) 
     //查询方法
    function SearchFunLib(){
         var fuzzyserch=$.trim($("#fuzzyserch").val());
         var ClassName=$.trim($("#ClassName").val()); /// 功能描述
         var ObjectDesc=$.trim($('#ObjectDesc').val());
         var datefrom=$("#checkdatefrom").datebox('getValue');  
         var dateto=$('#checkdateto').datebox('getValue');   // 获取日期输入框的值
         if ((datefrom>dateto)&&(dateto!="")&&(datefrom!=""))
         {
            $.messager.alert('错误提示','开始日期需小于结束日期!','error');
            return;
         }
         var UpdateUserDR= $.trim($("#UpdateUserDR").val());
         var OperateType= $('#OperateTypeD').combobox('getValue');  
       
         $('#mygrid').datagrid('load',  { 
              'dizzyDesc':fuzzyserch,
              'ClassN':ClassName,
              'OBJDESC':ObjectDesc,
              'datefrom':datefrom,
              'dateto':dateto,
              'UserDR':UpdateUserDR,
              'OperateTypeD': OperateType ,
              'UserClass':classparam
        });
    }
    
    //重置方法
    function ClearFunLib()
    { 
         $("#fuzzyserch").val("");
         $("#ClassName").val(""); /// 功能描述
         $('#ObjectDesc').val("");
         //$("#checkdatefrom").datebox('setValue', ""); 
         //$('#checkdateto').datebox('setValue', ""); // 设置日期输入框的值
         var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
     var titlenamearr=date.split("^");
     $("#checkdatefrom").datebox('setValue',titlenamearr[0]); 
       $('#checkdateto').datebox('setValue', titlenamearr[1]);
         $("#UpdateUserDR").val("");
         $('#OperateTypeD').combobox('setValue','');  
         if (classparam==undefined){
          classparam="";
         }
         $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.BDP.BDPDataChangeLog",
            QueryName:"GetList" ,
            UserClass:classparam
        }); 
        $('#mygrid').datagrid('unselectAll');
    }
      var columns =[[  
                  {field:'ClassNameDesc',title:'功能描述',width:160},
                  {field:'TableName',title:'表名称',width:160,hidden:true}, 
                  {field:'ClassName',title:'类名称',width:180,hidden:true},
                  {field:'ObjectReference',title:'对象ID',width:80,hidden:true},
                  {field:'ObjectDesc',title:'对象描述',width:150}, 
                  {field:'UpdateUserName',title:'操作人',width:120},
                  {field:'OperateType',title:'操作类型',width:80,
                    formatter:function(v,row,index){  
              if(v=='A'){return '添加';}
              if(v=='U'){return '修改';}
              if(v=='D'){return '删除';}
            }}, 
                  {field:'IpAddress',title:'操作人IP',width:120}, 
                  {field:'UpdateUserDR',title:'操作人ID',width:80,hidden:true},
                  {field:'UpdateDate',title:'操作日期',width:120},
                  {field:'UpdateTime',title:'操作时间',width:120}, 
                  {field:'ID',title:'ID',hidden:true}
              ]];
 
           
     $('#mygrid').datagrid({ 
            //striped : true,//设置为true将交替显示行背景
            fitColumns:true,//允许表格自动缩放，以适应父容器
            url: QUERY_ACTION_URL  ,     
            queryParams:{'MKBFlag':MKBFlag}, 
            //method:'get',
            ClassTableName:'User.BDPDataChangeLog',
      SQLTableName:'BDP_DataChangeLog',
            idField:'ID',
            dataType: 'json',
            fixRowNumber:true, //列号 自适应宽度
      rownumbers:true,    //设置为 true，则显示带有行号的列。
            pagination:true,//分页控件  
            singleSelect:true,
            columns:columns  ,
            pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
      pageSize:PageSizeMain,
      pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
          onDblClickRow: function (index, row) {   
              Viewlogdetail()
          },
          onLoadSuccess:function(data){
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
          }
     });
    
     ShowUserHabit('mygrid');
  var date=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
  var titlenamearr=date.split("^");
  $("#checkdatefrom").datebox('setValue',titlenamearr[0]); 
  $('#checkdateto').datebox('setValue', titlenamearr[1]);
  
};
$(init);