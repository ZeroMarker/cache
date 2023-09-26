///    @Title：诊断浏览器
///    @Creator:chenghegui
///    @Description:查看诊断图谱
///    @CreateDate：2018-03-28
Class web.DHCBL.MKB.MKBDiagBrowser Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##class(web.DHCBL.MKB.MKBDiagBrowser).DataCreat(2,8)
ClassMethod DataCreat(id, base) As %String
{
    new (id,base)
    s Mstr=""
    s Mstr=Mstr_","_"常用名"_","_"常用名拼音码"_","_"别名"
    
    s MKBProRowId=0,cat="",type="",catid="",det=""
    s jj=1
    for 
    {
        q:id=""
     
        s MKBProRowId=$o(^User.MKBTermPropertyI("TermIndex",id,MKBProRowId)) q:MKBProRowId=""
        s MKBProDesc=$LISTGET($G(^User.MKBTermPropertyD(MKBProRowId)),3)
        s MKBProDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBProDesc)
        s MKBProType=$LISTGET($G(^User.MKBTermPropertyD(MKBProRowId)),4)
        s Detail=##class(web.DHCBL.MKB.MKBTermProperty).GetALLDetail(MKBProType,MKBProRowId)
        s:Detail["<br/>" Detail=$tr(Detail,"<br/>","\n")
        s:Detail["<br>" Detail=$tr(Detail,"<br>","\n")
        s:Detail["</br>" Detail=$tr(Detail,"</br>","\n")
        s jj=jj+1
        s Mstr=Mstr_","_MKBProDesc
        s:cat'="" cat=cat_","_MKBProDesc
        s:cat="" cat=MKBProDesc
        s:catid'="" catid=catid_","_MKBProRowId
        s:catid="" catid=MKBProRowId
        s:type'="" type=type_","_MKBProType
        s:type="" type=MKBProType
        s:det'="" det=det_Detail_"^"
        s:det="" det=Detail_"^"
        }
    s MKBTermRowId=id
    s MKBTermCode=$listGet($g(^User.MKBTermD(MKBTermRowId)),2)  //代码
    s MKBTermDesc=$listGet($g(^User.MKBTermD(MKBTermRowId)),3)  //描述
    s MKBTermDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTermDesc)
    s:MKBTermDesc["<br/>" MKBTermDesc=$tr(MKBTermDesc,"<br/>","\n")
    s:MKBTermDesc["</br>" MKBTermDesc=$tr(MKBTermDesc,"</br>","\n")
    s:MKBTermDesc["<br>" MKBTermDesc=$tr(MKBTermDesc,"<br>","\n")
    //s TKBTRBDescU=$ZCONVERT(TKBTRBDesc,"U")_"]"
    s MKBTermPYCode=$listGet($g(^User.MKBTermD(MKBTermRowId)),6)  //检索码
    s MKBTermNote=$listGet($g(^User.MKBTermD(MKBTermRowId)),7) //备注
  
    s MKBTermNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTermNote) //处理有单引号不能显示的问题
    s:MKBTermNote["<br/>" MKBTermNote=$tr(MKBTermNote,"<br/>","\n")
    s:MKBTermNote["</br>" MKBTermNote=$tr(MKBTermNote,"</br>","\n")
    s:MKBTermNote["<br>" MKBTermNote=$tr(MKBTermNote,"<br>","\n")
    
    s MKBTermCodes="代码["_MKBTermCode_"]"  
    s MKBTermDescs=MKBTermDesc
    s MKBTermPYCodes="检索码["_MKBTermPYCode_"]"  
    s MKBTermNotes="备注["_MKBTermNote_"]"  
    
    
    s MKBTermCodeExt=..Ext(MKBTermCodes)
    s MKBTermPYCodeExt=..Ext(MKBTermPYCodes)
    s MKBTermNoteExt=..Ext(MKBTermNotes)
    
    s serchstr=MKBTermCodeExt_"^"_MKBTermPYCodeExt_"^"_MKBTermNoteExt
    n sort
    s sort=3
    s node="{id : 0,category : 0,name : '"_MKBTermDescs_"',value :'"_MKBTermDescs_"' ,label:{normal:{show:true,formatter:function(){var str='"_MKBTermDescs_"';return str}}},symbol : 'roundRect',symbolSize : [178,65]}"
    s node=node_","_"{id : 1,category : 1,name : '"_MKBTermCodeExt_"',value :'"_MKBTermCode_"' ,symbol : 'rect',symbolSize : [178,45],itemStyle:{normal:{color:'#60C0DD'}}}"
    s node=node_","_"{id : 2,category : 1,name : '"_MKBTermPYCodeExt_"',value :'"_MKBTermPYCode_"' ,symbol : 'rect',symbolSize : [178,55],itemStyle:{normal:{color:'#60C0DD'}}}"
    s:MKBTermNote="" node=node_","_"{id : 3,category : -1,name : '"_MKBTermNoteExt_"',value :'"_MKBTermNote_"' ,symbol : 'rect',symbolSize : [178,45],itemStyle:{normal:{color:'#60C0DD'}}}"
    s:MKBTermNote'="" node=node_","_"{id : 3,category : 1,name : '"_MKBTermNoteExt_"',value :'"_MKBTermNote_"' ,symbol : 'rect',symbolSize : [178,45],itemStyle:{normal:{color:'#60C0DD'}}}"

    s i=1
    for
    {
        s sort=sort+1
        s catdesc=$p(cat,",",i)
        s catId=$p(catid,",",i)
        s typeof=$p(type,",",i)
        s detil=$p(det,"^",i)
        s:typeof="SD" detil=##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(detil)
        s val=catId_","_typeof_"[AND]"_detil
        s catdesc=catdesc_"["_detil_"]"
        s catdesc=..Ext(catdesc)
        s serchstr=serchstr_"^"_catdesc
        s:detil'="" node=node_","_"{id : "_sort_",category : 2,name : '"_catdesc_"',value :'"_val_"' ,symbol : 'rect',symbolSize : [178,45],itemStyle:{normal:{color:'#B6A2DE'}}}"
        s:detil="" node=node_","_"{id : "_sort_",category : -1,name : '"_catdesc_"',value :'"_val_"' ,symbol : 'rect',symbolSize : [178,45],itemStyle:{normal:{color:'#B6A2DE'}}}"
        s i=i+1
        if (i>$L(cat,",")) 
        {
            q
        }
        }
    s num=($L(Mstr,",")+1)
    
    s lgdata="{name:'中心词',icon : 'roundRect'}"_","_"{name:'基本信息',icon : 'roundRect'}"_","_"{name:'属性',icon : 'roundRect'}"
    
    s categories="{name:'中心词',itemStyle:{normal:{color:'#FE8463'}}}"_","_"{name:'基本信息',itemStyle:{normal:{color:'#60C0DD'}}}"_","_"{name:'属性',itemStyle:{normal:{color:'#B6A2DE'}}}"
    s links="",sce=1
    for
    {
        s:links'="" links=links_","_"{source : "_sce_",target : 0}"
        s:links="" links="{source : "_sce_",target : 0}"
        s sce=sce+1
        if (sce=(num))  
        {
            q
        }
        }
    s serchlen=$L(serchstr,"^") 
    s sorts=1 , option=""
    for 
    {
        s:$p(serchstr,"^",sorts)'="" serchstrs=$p(serchstr,"^",sorts)
        if ($p($p($p(serchstr,"^",sorts),"[",2),"]",1)'="") 
        {
            s option=option_"<option value="""_serchstrs_""">"_serchstrs_" </option>"
        }
        s sorts=sorts+1
        
        if (sorts=serchlen) 
        {
            q
        }
    }
    w "<script type=""text/javascript"">// 基于准备好的dom，初始化ECharts实例",!
   // w "$(function() {",!
    w "var myChart = echarts.init(document.getElementById('main'), 'macarons');",!
    
    w "var option = {// 指定图表的配置项和数据",!
    w " title : {text: '知识浏览',subtext:'双击属性查看详细信息',bottom:'1%',right:'1%'},",!
    w " tooltip : {trigger:'item',hideDelay:200,position:function(point, params, dom) { if(params.value){var posDis = window.innerWidth - dom.offsetWidth;var lenDoc=params.value.length;return lenDoc>50?[point[0]+5,'10%']:[point[0]+10,point[1]+10] } /*var posDis = window.innerWidth - dom.offsetWidth; return posDis<point[0]?[posDis, '10%']:[point[0], '10%'];*/},transitionDuration:0.4,formatter: function(params){if(params.data.category==2){if(params.data.value){var res=params.data.value.split('[AND]')[1]}}else{if(params.data.value){var res=params.data.value}}   var newresName = """";if(res){ /*var jmz = {};jmz.GetLength = function(str) { return str.replace(/[\u0391-\uFFE5]/g,'aa').length; };var resNameNumber=jmz.GetLength(res);*/var resNameNumber = res.length};if(resNameNumber>150){var provideNumber = 30;} if(resNameNumber>350){var provideNumber = 40;} if(resNameNumber<=150) {var provideNumber=20;}var rowNumber = Math.ceil(resNameNumber / provideNumber);if (resNameNumber > provideNumber) { for (var p = 0; p < rowNumber; p++) {var tempStr = """";var start = p * provideNumber;var end = start + provideNumber; if (p == rowNumber - 1) { tempStr = res.substring(start, resNameNumber);} else {tempStr = res.substring(start, end) + ""</br>""; } newresName += tempStr;}} else {newresName = res; }return newresName}},",!
    w " legend : { ",!
    w "     type:'scroll',orient:'vertical',left:'1%',data : ["_lgdata_"]},",!
    w " series : [ {type : 'graph', name : ""诊断信息"",layout : 'force',hoverAnimation : true,",!
    w "     force : { repulsion : 100,gravity : 0.003,edgeLength :200,left:'10%',top:'middle',},",!
    w "     roam : true,nodeScaleRatio : 0.6,draggable : true,edgeSymbolSize : 10,itemStyle : {normal : { label : {show : true},borderType : 'solid',borderColor : '#99ccff',borderWidth : 0.5, opacity : 1},emphasis : {}},",!
    w "     lineStyle : { normal : {color : '#999999',width : '1.5',type : 'solid', curveness : 0.3, opacity : 1},emphasis : {}},",!
    w "     label : { normal : {position : 'inside',textStyle : {color : '#fff', fontStyle : 'normal',fontWeight : 'bolder',fontFamily : 'sans-serif', fontSize : 12, }}},",!
    w "     edgeLabel : { normal : {show : false},emphasis : {}},",!
    w "     data: ["_node_"],",!
    w "     categories : ["_categories_"],",!
    w "     links : ["_links_"]}]};",!
    w "myChart.setOption(option);",!
    w "function appendPath(params){",!
    w " var option = myChart.getOption();",!
    w " var series = option.series[params.seriesIndex];",!
    w " var nodesOption = series.data;",!
    w " var links= series.links;",!
    w " if(params.dataType==""node""){",!
    w "     var id=params.data.id;",!
    w "     var categoryName = series.categories[params.data.category].name;",!
    w "     if(params.data.category==2){var str=categoryName+"":""+params.data.name}else{var str=categoryName+"":""+params.data.value};",!
    w "     var i = 0;",!
    w "     var map = {};",!
    w "     for( i = 0 ; i < links.length; i++){",!
    w "         map[links[i].source] = links[i].target;",!
    w "     }",!
           
    w "     while(true){           ",!
    w "         if(map[id] == undefined){",!
    w "             break;",!
    w "         }",!
    w "         str =series.categories[nodesOption[map[id]].category].name+"":""+nodesOption[map[id]].name+""->"" + str; ",!
    w "         id = map[id] ;",!
    w "     }",!
    w "if(str.length>80){str=str.substring(0,80)+'...'}",!
    w "     return str;",!
    w " }else if(params.dataType==""edge""){",!
    w "     return """";",!
    w " }",!
    w "}",!
    
    w "function openOrFold(params) {",!
    w " var str = appendPath(params);",!
    w " document.getElementById(""main_1"").innerHTML = str;",!
    w " return str;",!
    w "}",!
    w "myChart.on('mouseover', openOrFold);",!
    w "</script>",!
    q ""
}

ClassMethod EvalJSON(instr As %String) As %String
{
    ;w ##class(web.DHCBL.MKB.TKBTrem).EvalJSON("a\")
    s mystr = instr
    
    q:(mystr="") mystr
    
    s mystr=$tr(mystr,"'","‘")
    
    s mystr=$tr(mystr,"""","”")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13), "")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10), "\n")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")
    
    s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10,10,10), "")
    
    q mystr
}

ClassMethod Ext(str) As %String
{
    s Extstr=""
    s len=$L(str)
    if (len>13)
    {
        s Extstr=$E(str,1,12)_"...]"
    }
    else 
    { 
        s Extstr=str
    }
    q Extstr
}

ClassMethod GetDetial()
{
}

}
