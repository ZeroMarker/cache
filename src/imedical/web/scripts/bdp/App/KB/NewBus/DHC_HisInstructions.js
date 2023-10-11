/*
Creator:张云越
CreatDate:2019-10-14
Description:知识库浏览器
*/

var countInfo=""  //小气泡显示的条数

var showData = function(){
   
    //如果是医生站调用该界面，则左侧面板隐藏
    if ((GenCode!= "")&(PointerCode!="")&(GenCode!=null)&(PointerCode!=null)&(GenCode!=undefined)&(PointerCode!=undefined))
    {
        //$('#mainlayout .layout-panel-west').css('display','none'); 
        //$("#mainlayout").layout("resize");
        var Pdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",GenCode);
        var PFdesc= tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenDesc",PointerCode);
        
        //alert(Pdesc);
        //alert(PFdesc);
        
        var GlPGenDr = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",GenCode);
        var GlPPointer = tkMakeServerCall("web.DHCBL.KB.DHCBusMain","getGenRowId",PointerCode);
        
        //alert(GlPGenDr);
        //alert(GlPPointer);
        
        if ((Pdesc=="") || (PFdesc=="") || (GlPGenDr=="-1") ||(GlPPointer=="-1"))
        {
            GenDesc = "未查询到该说明书"
        }
        else
        {
            document.getElementById('mainGrid').style.display='';  //显示mygrid
            $("#div-img").hide();        //初始图片消失
            GenDesc=Pdesc+"/"+PFdesc
            QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType);
        }
                    
        $("#drugDesc").html(GenDesc);
    }       
        
}

///知识库浏览器主界面
function InitMainList()
{
    var MAIN_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCBusMainNew&pClassMethod=GetDrugBookListNew";
    var mainclumns=[[ 
                  {field:'PHINSTDesc',title:'',width:800,
                    formatter: function(value,row,index){
                        if (row._parentId=="")
                        {
                            return ReturnFlagIcon(row.PHINSTGroupDesc)
                        }else{
                            //return '<div style="word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">'+value+'</div>';
                            return value
                        }
                    },
                    styler: function(value,row,index){
                        /*if (row._parentId==""){
                            return 'background-color:#bebec5;';  //#40a2de
                        }*/
                    }
                  }, 
                  //{field:'libdr',title:'libdr',hidden:true}, 
                  {field:'PHINSTGroupDesc',title:'知识库标识',hidden:true}, 
                  {field:'PHINSTSoft',title:'排序',hidden:true},   
                  {field:'PHINSTCount',title:'数量',hidden:true},
                  {field:'id',title:'id',hidden:true},
                  {field:'_parentId',title:'parentId',hidden:true}
                  ]];
    $('#mainGrid').treegrid({ 
        url:MAIN_QUERY_ACTION_URL,
        columns:mainclumns,
        width:'100%',
        height:'100%',
        showHeader:false,
        pagination: false, 
        pageSize:1000,
        pageList:[1000],
        toolbar:'#mainbar',
        fitColumns: true,
        loadMsg:'数据装载中......',
        autoRowHeight: true,
        singleSelect:true,
        idField:'id', 
        treeField:'PHINSTDesc',
        rownumbers:false,
        fit:true,
        remoteSort:false,
        //sortName:"EpisodeID",
        onLoadSuccess:function(node, data){
            //去掉treegrid结点前面的文件及文件夹小图标
            $("#mainGridDiv .tree-icon,#mainGridDiv .tree-file").removeClass("tree-icon tree-file");
            $("#mainGridDiv .tree-icon,#mainGridDiv .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
        }
    });
    
    
}

//查询方法
function SearchFunLib(){
    var HisDescID=$.trim($('#HisGen').combobox('getValue'));
    var HisDesc=$.trim($('#HisGen').combobox('getText'));
    var PointerDr=$.trim($('#LinkGen').combobox('getValue'));
    var PointerDesc=$.trim($('#LinkGen').combobox('getText'));
    if(HisDescID=="")
    {
        alert("请输入完整的描述");
    }
    else
    {
        var GenDesc=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getGenDesc",HisDescID);  //根据His数据对照ID获取通用名描述
        var GenDr=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getGenDr",GenDesc); //根据通用名获取通用名id
        if (GenDr=="")
        {
            $("#drugDesc").html("<h2 style='color:black;'>"+""+"</h2>");
            $("#div-img").show();        //初始图片展示
            alert("知识库内容未配置完整");
        }
        else
        {
            var LibDesc=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getLibDesc",GenDr); //通过通用名id查询知识库标识的描述       
            if(LibDesc=="药品")
            {
                var PointerDr=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","GetFormDr",HisDesc); //根据His描述获取关联id
                var Desc=HisDesc //药品不加剂型
            }
            else
            {
                if(PointerDr=="") 
                {
                    var PointerDr=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getPointerDr",GenDr); //根据通用名id获取关联id
                    if (PointerDr!="")
                    {
                        var PointerDesc=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","GetPointerDesc",PointerDr,LibDesc) //根据关联id和知识库标识id获取关联描述
                    }
                }           
                var Desc=HisDesc+"/"+PointerDesc
            }
            document.getElementById('mainGrid').style.display='';  //显示mygrid
            $("#div-img").hide();        //初始图片消失
            if(PointerDr=="")
            {
                $("#drugDesc").html("<h2 style='color:black;'>"+""+"</h2>");
                $("#div-img").show();        //初始图片展示
                alert("知识库内容未配置完整");
            }
            else 
            {
                $("#drugDesc").html("<h2 style='color:black;'>"+Desc+"</h2>");
                QueryMainGrid(GenDr,PointerDr,"Form");
            }
        }
    }
}

function GenerateCom()
{
    $('#LinkGen').combobox('clear');//清空
    var HisDescID=$.trim($('#HisGen').combobox('getValue'));
    if(HisDescID=="")
    {
        alert("请输入正确的完整描述");
    }
    else
    {
        var GenDesc=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getGenDesc",HisDescID);  //根据His数据对照ID获取通用名描述
        var GenDr=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getGenDr",GenDesc); //根据通用名获取通用名id
        if (GenDr=="")
        {
            $("#drugDesc").html("<h2 style='color:black;'>"+""+"</h2>");
            $("#div-img").show();        //初始图片展示
            alert("知识库内容未配置完整");
            return
        }
        var LibDesc=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","getLibDesc",GenDr); //通过通用名id查询知识库标识的描述
        var Flag=tkMakeServerCall("web.DHCBL.KB.DHCHisInstructions","GetFlag",GenDr); //通过通用名id查询关联是否唯一
        /*if(Flag=="")
        {
            $("#drugDesc").html("<h2 style='color:black;'>"+""+"</h2>");
            $("#div-img").show();        //初始图片展示
            alert("知识库内容未配置完整");
            return
        }*/
        if(LibDesc=="药品") //药品-剂型
        {
            $('#LinkGen').next(".combo").hide();//$('#typeId').next(".combo").show();
            $('#LinkGen').combobox('clear');//清空
            SearchFunLib();
            /*$('#LinkGen').combobox({ 
                url:$URL+"?ClassName=web.DHCBL.KB.DHCHisInstructions&QueryName=GetDataForCmbDrug&ResultSetType=array&GenDr="+GenDr,
                valueField:'PointerId',
                textField:'PHEFDesc',
                onSelect:function(record){
                    SearchFunLib();    
                }
            });*/
        }
        else if(LibDesc=="检验项目") //检验-标本
        {
            SearchFunLib();
            if(Flag==1)
            {
                $('#LinkGen').next(".combo").hide();//$('#typeId').next(".combo").show();
                $('#LinkGen').combobox('clear');//清空
            }
            else
            {
                $('#LinkGen').next(".combo").show();
                $('#LinkGen').combobox({ 
                    url:$URL+"?ClassName=web.DHCBL.KB.DHCHisInstructions&QueryName=GetDataForCmbLab&ResultSetType=array&GenDr="+GenDr,
                    valueField:'PointerId',
                    textField:'PHEGDesc',
                    onSelect:function(record){
                        SearchFunLib();    
                    }
                });
            }

        }
        else //if(LibDesc=="检查项目"||LibDesc=="超声"||LibDesc=="放射"||LibDesc=="内镜"||LibDesc=="心电") //检查-部位 
        {
            SearchFunLib();
            if(Flag==1)
            {
                $('#LinkGen').next(".combo").hide();//$('#typeId').next(".combo").show();
                $('#LinkGen').combobox('clear');//清空
            }
            else
            {
                $('#LinkGen').next(".combo").show();
                $('#LinkGen').combobox({ 
                    url:$URL+"?ClassName=web.DHCBL.KB.DHCHisInstructions&QueryName=GetDataForCmbCheck&ResultSetType=array&GenDr="+GenDr,
                    valueField:'PointerId',
                    textField:'PHEPDesc',
                    onSelect:function(record){
                        SearchFunLib();    
                    }
                });  
            }                  
        }
    }
}

///界面加载代码
function BodyLoadHandler()
{
    $('#LinkGen').next(".combo").hide(); //隐藏关联下拉框
    $('#HisGen').combobox({ 
        url:$URL+"?ClassName=web.DHCBL.KB.DHCHisInstructions&QueryName=GetDataForCmb1&ResultSetType=array",
        valueField:'GICTRowId',
        textField:'GICTHisDesc',
        onSelect:function(record){
            //SearchFunLib();    
            GenerateCom();
        }
    });
    
    //His描述绑定键盘事件
    $('#HisGen').combobox('textbox').bind('keyup',function(e){ 
        if(e.keyCode==13){ 
            //SearchFunLib();
            GenerateCom();
        }
        if(e.keyCode==27){
            ClearFunLib();
        }
    });  

    //关联绑定键盘事件
    $('#LinkGen').combobox('textbox').bind('keyup',function(e){ 
        if(e.keyCode==13){ 
            SearchFunLib();
            //GenerateCom();
        }
        if(e.keyCode==27){
            ClearFunLib();
        }
    });   
    
    //主面板treegrid  
    InitMainList();
    $('#mainGrid').treegrid('loadData', {total:0,rows:[]}); 
    
    //医生站端调浏览器
    showData();

}


//重置方法
function ClearFunLib()
{
    //$("#textDesc").val("")
    $('#HisGen').combobox('clear');//清空
    $('#LinkGen').next(".combo").hide();
    $('#LinkGen').combobox('clear');//清空
    document.getElementById('mainGrid').style.display='';  //显示mygrid
    $("#div-img").show();        //初始图片展示
}

//加载浏览器数据
function QueryMainGrid(GlPGenDr,GlPPointer,GlPPointerType)
{
    $('#mainGrid').treegrid('load',  {  
        'GenDr':GlPGenDr,
        'PointerType':GlPPointerType,
        'PointerDr':GlPPointer
    });
    /*$('#mainGrid').treegrid('loadData',{"total":2,"rows":[
        {"id":13,"PHINSTDesc":"相互作用"},
        {"id":11,"PHINSTDesc":"测试相互作用","_parentId":13}
        ]
    });*/

}


/**用于Grid中返回组图片**/
//蔡昊哲   谷雪萍修改-显示顺序2017-08-29
ReturnFlagIcon = function(value)
{
    var returnValue = "";
    //var value=parseInt(value);
    switch(value)
    {
      case "成分含量(g)":  //"成分含量(g)"  <span style='font-size:24px'>
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/zzndhl.png' style='border: 0px'><span style='font-size:16px'>"+"【成分含量(g)】"+"</span>";
      break;
      case "适应证": //"适应证"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/syz.png' style='border: 0px'><span style='font-size:16px'>"+"【适应证】"+"</span>";
      break;
      case "用法用量":  //"用法用量"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yfyl.png' style='border: 0px'><span style='font-size:16px'>"+"【用法用量】"+"</span>";
      break;
      case "溶媒量":  //"溶媒量"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/rml.png' style='border: 0px'><span style='font-size:16px'>"+"【溶媒量】"+"</span>";
      break;
      case "浓度": //"浓度"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lcyy.png' style='border: 0px'><span style='font-size:16px'>"+"【浓度】"+"</span>";
      break;
      case "给药途径":  //"给药途径"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yyff.png' style='border: 0px'><span style='font-size:16px'>"+"【给药途径】"+"</span>";
      break;          
      case "用药频率":  //"用药频率"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/yypl.png' style='border: 0px'><span style='font-size:16px'>"+"【用药频率】"+"</span>";
      break;
      case "滴速":  //"滴速"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/ds.png' style='border: 0px'><span style='font-size:16px'>"+"【滴速】"+"</span>";
      break;
      case "不良反应":  //"不良反应"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/blfy.png' style='border: 0px'><span style='font-size:16px'>"+"【不良反应】"+"</span>";
      break;
      case "禁忌证":  //"禁忌证"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/jjz.png' style='border: 0px'><span style='font-size:16px'>"+"【禁忌证】"+"</span>";
      break;
      case "配伍禁忌":  //"配伍禁忌"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/jj.png' style='border: 0px'><span style='font-size:16px'>"+"【配伍禁忌】"+"</span>";
      break;
      case "注意事项":  //"注意事项"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/zysx.png' style='border: 0px'><span style='font-size:16px'>"+"【注意事项】"+"</span>";
      break;          
      case "相互作用":  //"相互作用"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/xhzy.png' style='border: 0px'><span style='font-size:16px'>"+"【相互作用】"+"</span>";
      break;
      case "可配伍药品":  //"可配伍药品"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/ddyy.png' style='border: 0px'><span style='font-size:16px'>"+"【可配伍药品】"+"</span>";
      break;
      case "联合用药":  //"联合用药"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/lhyy.png' style='border: 0px'><span style='font-size:16px'>"+"【联合用药】"+"</span>";
      break;
      case "辅助用药个数":  //"辅助用药个数"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/fzyygs.png' style='border: 0px'><span style='font-size:16px'>"+"【辅助用药个数】"+"</span>";
      break;
      case "重复用药":  //"重复用药"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/cfyy.png' style='border: 0px'><span style='font-size:16px'>"+"【重复用药】"+"</span>";
      break;
      case "炮制作用":  //"炮制作用"
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/pzzy.png' style='border: 0px'><span style='font-size:16px'>"+"【炮制作用】"+"</span>";
      break;
      /*case "别称":
      returnValue = "<img src='../scripts/bdp/Framework/imgs/KB/Alias32.png' style='border: 0px'><span style='font-size:24px'>"+value+"</span>";
      break;*/
      default:  //"其他"
      returnValue = "<span style='font-size:16px'>"+"【其他】"+"</span>";
    } 
    return returnValue;
}   
    
