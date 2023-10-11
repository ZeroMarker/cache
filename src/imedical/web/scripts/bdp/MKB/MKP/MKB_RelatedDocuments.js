/** 
 * @Title: 相关文献查询
 * @Description:根据诊断获查询相关文献
 * @Creator: 高姗姗
 * @Created: 2018-05-15
 */
var rowidstr = GetParams("diag");
 function GetParams(name){
        var search = document.location.search;
        var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");
        var matcher = pattern.exec(search);
        var items = null;
        if(null != matcher){
                try{
                        items = decodeURIComponent(decodeURIComponent(matcher[1]));
                }catch(e){
                        try{
                                items = decodeURIComponent(matcher[1]);
                        }catch(e){
                                items = matcher[1];
                        }
                }
        }
        return items;
};
var init = function(){
    var columns =[[
    	//MKBDMRowId,MKBDMCode,MKBDMDesc,MKBDMSource,MKBDMType,MKBDMUpdateUser,SSUSRName,MKBDMUpdateDate,MKBDMFlag,MKBDMNote,MKBDMPath
        {field:'MKBDMCode',title:'代码',hidden:true},
        {field:'MKBDMDesc',title:'文献名称',width:100,sortable:true},
        {field:'MKBDMSource',title:'出处',width:100,sortable:true},
        {field:'SSUSRName',title:'上传人',width:100,sortable:true},
        {field:'MKBDMUpdateDate',title:'上传时间',width:100,sortable:true},
        {field:'MKBDMFlag',title:'审核状态',width:100,sortable:true,
            formatter: function(value,row,index){
                if(value=='F')  //初传
                {
                    return $g("初传")
                }
                else if(value=='N') //审核不通过
                {
                    return $g("审核不通过");
                }
                else if(value=="Y")
                {
                    return $g("审核通过"); //审核通过
                }
            }
        },
        {field:'MKBDMNote',title:'备注',width:100,sortable:true},
        {field:'MKBDMUpdateUser',title:'上传人id',hidden:true},
        {field:'MKBDMType',title:'类型',hidden:true,
            formatter: function(value,row,index){
                if(value=='D')  //初传
                {
                    return "doc"
                }
                else if(value=='F') //审核不通过
                {
                    return "pdf";
                }
                else if(value=="E")
                {
                    return "excel"; //审核通过
                }
            }

        },
        {field:'MKBDMPath',title:'路径',hidden:true},
        {field:'MKBDMRowId',title:'MKBDMRowId',hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#docgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetailInterface",
            QueryName:"GetDoc",
            'str':rowidstr
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        idField:'MKBDMRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onClickRow:function(index,row)
        {
             ClickMyGrid();
        }
    });
	//启用预览按钮
    function ClickMyGrid( )
    {
        var record = $("#mygrid").datagrid("getSelected");
        if (record){
            var fileType = (record.MKBDMPath).split(".")[(record.MKBDMPath).split(".").length-1];
            var PDFisExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+(record.MKBDMPath).replace(fileType,"pdf"));
            if(PDFisExists==1)
            {
                $("#pre_btn").linkbutton('enable');
            }
            else
            {
                $("#pre_btn").linkbutton('disable');
            }

        }
    }
    $('#pre_btn').click(function (e){
        previewFile();
    });
    //单独给上传按钮引用样式，为了不和class冲突
    $('#onload_btn').click(function (e){
        DownLoadFile();
    });
/*    //查询按钮
    $("#RelatedDesc").searchbox({
        searcher:function(value,name){
            SearchFunLib();
        }
    })
    //查询方法
    function SearchFunLib(){
        var desc=$.trim($('#RelatedDesc').searchbox('getValue'));
        $('#docgrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetailInterface",
            QueryName:"GetDoc"	,
            'desc': desc
        });

    }
    //重置按钮
    $("#RDRefresh").click(function (e) {

        ClearFunLib();
    })
    //重置方法
    function ClearFunLib()
    {
        $("#RelatedDesc").searchbox('setValue', '');
        $('#docgrid').datagrid('load',  {
            ClassName:"web.DHCBL.MKB.MKBKLMappingDetailInterface",
            QueryName:"GetDoc"
        });
        $('#docgrid').datagrid('unselectAll');
    }*/
    //点击预览按钮
    function previewFile()
    {
        var record=mygrid.getSelected();
        if(record)
        {
            var fileType = (record.MKBDMPath).split(".")[(record.MKBDMPath).split(".").length-1];
            var PDFisExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+(record.MKBDMPath).replace(fileType,"pdf"));
            if(PDFisExists==1)
            {
                fileName=record.MKBDMPath;
                var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
                //$('#win').html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data='+filepath+' style="display:block"> <div id="PDFNotKnown">你需要先安装pdf阅读器才能正常浏览文件，请点击<a href="http://get.adobe.com/cn/reader/download/?installer=reader_11.0_chinese_simplified_for_windows" target="_blank">这里</a>下载.</div> </object>');
                
                $('#win').html("<a id='mediaHelp1' href='"+filepath+"'></a>");
			  	$('#mediaHelp1').media({width:850 , height:550 });
			  	var userAgent = navigator.userAgent; 
			  	if(userAgent.indexOf('Safari')>-1){
			    	var previewWin = $HUI.dialog("#win",{
                    	width:850,
                		height: 550,
                    	modal:true,
                    	title:fileName
                	});
                 	previewWin.show();
			  	}
            }
            else
            {
            	$.messager.popover({msg: '不存在pdf预览文件！',type:'success',timeout: 1000});
            }
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
    //点击下载按钮
    function DownLoadFile()
    {
        //alert(document.getElementById("onload_btn").className);
        var record=mygrid.getSelected();
        if(record)
        {
	        $(".load").attr("href","#");
	        $(".load").removeAttr("download");
	        $(".load").removeAttr("target");
            var fileName=record.MKBDMPath;
            var isExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName);
            filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName;
            if(isExists==1)
            {
                $(".load").attr("href",filepath);
                $(".load").attr("download",fileName);
                //var filepath = "../scripts/bdp/Framework/NDoc/"+fileName;
                //window.open(filepath,"_self");
                //判断浏览器是否支持a标签 download属性
                var isSupportDownload = 'download' in document.createElement('a');
                if(!isSupportDownload){
                    var fileType = fileName.split(".")[fileName.split(".").length-1];
                    if((fileType!="pdf")&&(fileType!="PDF")){
                        objIframe=document.createElement("IFRAME");
                        document.body.insertBefore(objIframe);
                        objIframe.outerHTML=   "<iframe   name=a1   style='width:0;hieght:0'   src="+$(".load").attr("href")+"></iframe>";
                        pic   =   window.open($(".load").attr("href"),"a1");
                        document.all.a1.removeNode(true)
                    }else{
                        alert("此浏览器使用另存下载");
                        $(".load").attr("target","_blank");
                    }
                }
            }
            else
            {
            	$.messager.popover({msg: '该文件不存在！',type:'success',timeout: 1000});
            }
        }
        else
        {
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    
    
}
$(init);