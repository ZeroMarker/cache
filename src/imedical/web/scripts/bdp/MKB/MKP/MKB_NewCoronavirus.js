/**   
 * @Title: 医为百科 
 * @Description:查看知识
 * @author: 石萧伟
 * @Created:  2018-05-18  
 * @Edit:  2020-03-31 谷雪萍  
 */

$(function(){
	/*window.onresize = function(){
		location.reload()
	}*/
	//var filename = "../../../Doc/Doc/新型冠状病毒肺炎诊疗方案（试行第七版）.pdf"
	//document.getElementById('dociframe').src="../scripts/bdp/MKB/MKP/pdfjs/web/viewer.html?file=../../../Doc/Doc/新型冠状病毒肺炎诊疗方案（试行第七版）.pdf"+encodeURIComponent(filename)
   $.fn.datagrid.defaults.onHeaderContextMenu = function(){};   //屏蔽表头右键功能
   $.fn.treegrid.defaults.onHeaderContextMenu =  function(){}; 
   //var termdr=GetURLParams("id");
   //var base= GetURLParams("base");
   var count=0;  //记录目录条数
   if(termdr==null || termdr==""){
        termdr="1650775";  //默认展示 肺癌
   }
   if(base==null || base==""){
       base=5;
   }
   ///chenying
   //var termdrDesc=$.m({EncryItemName:upws0,id:termdr},function(){}) 
   var termdrDesc=$.m({ClassName:"web.DHCBL.MKB.MKBTerm",MethodName:"GetDesc",id:termdr},false);
   String.addSpace=function(str){
            return str.split("").join(" ");
   };
   termdrDesc = String.addSpace(termdrDesc);
    $.m({
        ClassName:"web.DHCBL.MKB.MKBEncyclopedia",
        MethodName:"GetTermInfo",
        id:termdr
    },function(textData){
       var  textData= eval('('+textData+')');  
       //console.log(textData)
	   //基本信息
       $("#head_h1").html(termdrDesc+"<p style='text-align:left;margin-left:17px;font-weight:bold'>基本信息：</p>"+"<p style='text-indent:2em;text-align: left;margin-left:17px;width:95%' id='head_h11'>"+textData.MKBTNote+"</p><table id='baseinfotable' style='margin:15px 17px'><tbody><tr><td class='tdname'>别名:</td><td class='tdvalue'>"+textData.MKBTOther.split("||")[0]+"</td></tr></tbody></table>");
       //只有新型肺炎展示预览20200206
       if(termdr=="1650775"){
	          $("#head_h1").after("<div id='linktab' class='changetab' style='height:50px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'>文献(0)</span></i></a><a class='changetabs'><i><span>诊疗方案第七版<span></i></a></div>")
	   }else{
       		  $("#head_h1").after("<div id='linktab' class='changetab' style='height:50px;background-color:#f4f6f5;width:95%;border-bottom:#40a2de solid 1px;margin-left:50px'><a class='changetabs select'><i><span>知识概况<span></i></a><a class='changetabs'><i><span id='docnum'>文献(0)</span></i></a></div>")		   
	   }
       /*$("#changeview").click(function(e){
           var _height=document.documentElement.clientHeight || document.body.clientHeight;
           var _width = document.documentElement.clientWidth || document.body.clientWidth;
           $("#iframeview").css("height",_height-20);
           $("#iframeview").css("width",_width);
           if( $("#iframeview").css("display")=="none"){
                $("#head_h").css("display","none");
                $("#iframeview").css("display","block");
                $("#directory-navbefore").css('display','none');
                $("#iframeview").attr("src","dhc.bdp.mkb.mkbdiagbrowser.csp?termdr="+termdr+"&base="+base)
                $("#changeview").css("padding-right","8px");

                $("body").css("padding","0");
           }else{
                $("#iframeview").css("display","none");
                $("#head_h").css("display","block");
                $("#changeview").css("padding-right","0");
                $("#directory-navbefore").css('display','block');
                $("body").css("padding","0 100px 0 100px")
           }
       })*/
       $(".changetabs").click(function(e){
             if(!$(this).hasClass("select")){
                 $(this).addClass('select');
                 $(this).siblings().removeClass('select');
                 if($(".select").text()!="知识概况"&&$(".select").text()!="诊疗方案第七版"){
                    $("#infoflag").val("doc")
                   $(".displaycontent").css('display','none');
                   $("#countheight").css('display','none');
                   $("#directory-navbefore").css('display','none');
                   $("#directory-navbefore").remove();
                   $("#relationdoc").css('display','block');
                   if(count==0){
                       $("#nulldiv").css("display","none");
                    }
                    $("#previewdoc").css("display","none");
                    $('#doclay').panel('resize')
                 }else if($(".select").text()=="知识概况"){
	                setTimeout(function(){directoryNav = new DirectoryNav($("h2,h3"),{
            			scrollTopBorder:300 //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
        			});},1000);  //需要加延时 解决获得高度不准问题
                    $("#directory-navbefore").css('display','block');
                    $(".displaycontent").css('display','block');
                    $("#countheight").css('display','block'); 
                    if(count==0){
                         $("#countheight").css("display","none")
                         $("#nulldiv").css("display","block")
                    }
                    $("#relationdoc").css('display','none');
                    $("#previewdoc").css("display","none");
                 }else{
//	                 	$('#previewdoc a.mediaF').media({
//							 width:$(window).width()*8.95/10, 
//							 height:$(window).height()*8.6/10
//						});  
	                 	$.m({ClassName:"web.DHCBL.BDP.BDPVisitLog",MethodName:"SaveData",SaveDataStr:session['LOGON.SITECODE']+'&%R&%&%&%新型冠状病毒肺炎诊疗方案（试行第七版）.pdf'},false);
	                 	$('html,body').animate({scrollTop: $("#linktab").offset().top}, 500); //滚动效果
	             	    $("#previewdoc").css("display","block");
	             	    $("#relationdoc").css('display','none');
	             	    $("#directory-navbefore").css('display','none');
                    	$(".displaycontent").css('display','none');
                    	$("#countheight").css('display','none'); 
                   		if(count==0){
                       		$("#nulldiv").css("display","none");
                       		
                    	}
	             }
             }
         })
         
    })
   //展示医为百科首页的所有属性及内容
   $.cm({
        ClassName:"web.DHCBL.MKB.MKBEncyclopedia",
        QueryName:"GetList",
        termdr:termdr
    },function(jsonData){
       var deschtml="";
       var iframhtml=""
       var ahtml="";
       for(var j = 0,len=jsonData.rows.length; j < len; j++)
       {
            var MKBTPDesc = jsonData.rows[j].MKBTPDesc;
            var MKBTPRowId =jsonData.rows[j].MKBTPRowId;
			var MKBTPDesc1 = jsonData.rows[j].MKBTPDesc;
            if (MKBTPDesc.length>8) 
            {
                MKBTPDesc=MKBTPDesc.substring(0,6)+"...";
            }// 知识点下拉框

			var type=jsonData.rows[j].MKBTPType;
			
            //if (termdr!=1650775){
			//自动生成属性标题及内容框部分
	        deschtml="<div class='displaycontent' style='display:block;'>" +
	        		   "<h2 id='h"+j+"'>" +
	        				"<div style='border-left:#4F9CEE solid 12px;height:28px;width:1%;display:block;margin-left:0;float:left;display:inline-block;'>" +
	        				"</div>" +
	        				"<div style='margin:10px 0 0 35px;width:83%;height:28px;'>" +
	        					"<div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>"+MKBTPDesc1+"" +
	        					"</div>" +
	        				"</div>" +
	        				"<div style='width:20px;margin-right:14%;margin-top:-22px;height:20px;background-color:#FFFFFF'>" +
	        				"</div>" +
	        		   "</h2>" +
	        		   "<div style='width:78.8%;border:#ccc solid 0.5px;margin-left:50px'>" +
	        		   "</div>" +
	        		   "<div id='div"+j+"' style='height:auto;margin-top:10px;margin-left:50px;width:78.8%;border:1px solid #C0C0C0;border-radius:4px'>" +
	        		   "</div>" +
	        		"</div>";
	        
	        //右下角目录
	        ahtml=ahtml+"<li style='float:left;padding:2px 5px 2px 5px;width:16%'>" +
	        		        "<a  href='javascript:void(0)' id='ah"+j+"' onclick=moreCount('"+"h"+j+"')>"+MKBTPDesc+"</a>" +
	        			"</li>";
	       
            
			var propertyid=MKBTPRowId;
            var propertyName=jsonData.rows[j].MKBTPName;
            if (propertyName=="")
            {
                propertyName=MKBTPDesc
            }
            $("#head_h").append(deschtml);
			$(".commit").tooltip({
				content:'<span>知识提交</span>',
				position: 'left', //top , right, bottom, left
				onShow: function(){    
					$(this).tooltip('tip').css({
					backgroundColor: '#666', 
					borderColor: '#666'
				});   
				}
			})
             //获取扩展属性信息
            var extendInfo=$.m({ClassName:'web.DHCBL.MKB.MKBTermProDetail',MethodName:'getExtendInfo',property:propertyid},false);
            var extend=extendInfo.split("[A]")
            var propertyName = extend[0];  //主列名
            var extendChild =extend[1];  //扩展属性child串
            var extendTitle =extend[2];  //扩展属性名串
            var extendType =extend[3];    //扩展属性格式串 
            var extendConfig =extend[4];    //扩展属性配置项串
            //树形和列表型属性的列
            var columns =[[  
                            {field:'id',title:'id',width:80,hidden:true,resizable:false},
                            {field:'MKBTPDDesc',title:propertyName,resizable:false,width:100/*,
								formatter: function(value,row,index){
									return "<span style='white-space:nowrap;'>"+value+"</span>"
								}*/
							},
                            {field:'MKBTPDRemark',title:'详情',width:150,resizable:false},
                            {field:'MKBTPDLastLevel',title:'上级分类',width:100,resizable:false,hidden:true},
                            {field:'MKBTPDSequence',title:'顺序',width:100,resizable:false,hidden:true}
                        ]];
            
            if (extendChild!="" && termdr!="1650775")   //如果有扩展属性，则自动生成列  新型肺炎只显示备注20200206
            {
                var colsField = extendChild.split("[N]"); 
                var colsHead = extendTitle.split("[N]"); 
                var typeStr = extendType.split("[N]"); 
                var configStr = extendConfig.split("[N]"); 
                for (var i = 0; i <colsField.length; i++) {
                    //添加列 方法2
                    var column={};  
                    column["title"]=colsHead[i];  
                    column["field"]='Extend'+colsField[i];  
                    column["width"]=150;  
                    column["sortable"]=false;
                     column["resizable"]=false; 
                    columns[0].push(column)
                    }
            }     
            if(type=="L")
            {
               iframhtml='<table id="llist'+j+'" border="false" ></table>'
               $("#div"+j).append(iframhtml);
           		var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
				//列表datagrid
				var mygrid = $HUI.datagrid("#llist"+j,{
					url:QUERY_ACTION_URL+"&property="+propertyid+"&rows=9999999&page=1",
					columns:columns,
					pagination:false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                    singleSelect:true,
                    idField:'MKBTPDRowId',   
                    autoRowHeight:true,  //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能。
                    nowrap:false,  //设置为 true，则把数据显示在一行里。设置为 true 可提高加载性能。
                    autoSizeColumn:true, //调整列的宽度以适应内容。
                    fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                    scrollbarSize:0,
                    onLoadSuccess:function(data){
                        //console.log(data)
                        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);

                    }

				});    
            }
            else if(type=="T")
            {     
               iframhtml="<table border='false' id='treegrid"+j+"'></table>"
               $("#div"+j).append(iframhtml);
               var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBEncyclopedia&pClassMethod=GetJsonList";
                //列表datagrid
                var mygrid = $HUI.treegrid("#treegrid"+j,{
                    url:QUERY_ACTION_URL+"&property="+propertyid,
                    columns:columns,
                    idField: 'id',
                   // lines:true,
                    autoRowHeight:true,
                    nowrap:false,
                    treeField:'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
                    autoSizeColumn:true,
                    animate:false,     //是否树展开折叠的动画效果
                    fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                    remoteSort:false, //定义是否从服务器排序数据。true
                    scrollbarSize:0,
                    onLoadSuccess:function(data){
                        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);

                    }
                });
            }
            else if((type=="TA")||(type=="TX")||(type=="C")||(type=="CB")||(type=="R")||(type=="F")||(type=="SD"))
            {
                 var tmpdesc =$.m({ClassName:'web.DHCBL.MKB.MKBEncyclopedia',MethodName:'GetDetailDesc',id:propertyid,type:type},false);
                 iframhtml="<span>"+tmpdesc+"</span>";
                 $("#div"+j).append(iframhtml);
            }
            else if(type=="P")
            {
                 iframhtml='<table data-options="fit:false" id="plist'+j+'" border="false" ></table>'
                 $("#div"+j).append(iframhtml);
                 //datagrid列
                var pcolumns =[[   
                    {field:'MKBTPRowId',title:'RowId',width:80,hidden:true,resizable:false},
                    {field:'MKBTPDesc',title:'属性',width:150,resizable:false},
                    {field:'MKBTPType',title:'格式',width:150,resizable:false,hidden:true},
                    {field:'MKBTPShowType',title:'展示格式',width:150,resizable:false,
                        formatter:function(v,row,index){  
                            if(v=="C"){return "下拉框"}
                            if(v=="T"){return "下拉树"}
                            if(v=="TX"){return "文本框"}
                            if(v=="TA"){return "多行文本框"}
                            if(v=="CB"){return "单选框"}
                            if(v=="CG"){return "复选框"}
                            if(v=="MC"){return "多选下拉框"}                         
                        }
                    },
                    {field:'MKBTPTreeNode',title:'定义节点',width:150,resizable:false,
                        formatter:function(v,row,index){ 
                        if(v){
                           var showvalue=$.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetDesc",id:v},false);
                            return showvalue 
                          }else{
                             return "暂无";
                            }                      
                        }
                    },
                    {field:'MKBTPChoice',title:'单选/复选',width:150,resizable:false,
                        formatter:function(v,row,index){  
							if(v=="D"){
								return "多选"
							}
							else{
								return "单选"
							}
						}
						
                    },
					{field:'MKBTPRequired',title:'是否必填',width:150,sortable:true,
						formatter:function(v,row,index){  
							if(v=="Y"){
								return "必填"
							}
							else{
								return "不必填"
							}
						}
					}
                ]]; 
                //列表datagrid
                //console.log(columns)
               $HUI.datagrid("#plist"+j,{
                    url:$URL,
                    queryParams:{
                        ClassName:"web.DHCBL.MKB.MKBTermProDetail",
                        QueryName:"GetSelPropertyList",
                        property:propertyid
                    },
                    columns:pcolumns,
                    pagination:false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
                    singleSelect:true,
                    idField:'MKBTPRowId', 
                    rownumbers:false,    //设置为 true，则显示带有行号的列。
                    fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
                    scrollbarSize:0,
                    onLoadSuccess:function(data){
                        //console.log(data)
                        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);

                    }
                }); 
            }
            else if(type=="S")
            {
                 var configListOrTree = $.m({ClassName:"web.DHCBL.MKB.MKBTermProDetail",MethodName:"GetProListOrTree",property:propertyid},false);  //引用术语是树形还是列表型
                 if(configListOrTree=="T")
                 {
                    iframhtml ='<table id="treeterm'+j+'" data-options="fit:false,border:false"></table>';
                    $("#div"+j).append(iframhtml);
                    $HUI.tree('#treeterm'+j,{
                        url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&property="+propertyid,
                        lines:true,  //树节点之间显示线条
                        autoSizeColumn:true,
                        id:'id',//这里的id其实是所选行的idField列的值
                        cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作     
                        animate:false,   //是否树展开折叠的动画效果 
                        onExpand:function(node){
                        },
                        onCollapse:function(node){
                        }
                    });
                 }
                 else
                 {
				       iframhtml ='<table id="listterm'+j+'" data-options="fit:false,border:false"></table>';
					   $("#div"+j).append(iframhtml);
						   //datagrid列
					    var columns =[[  
								{field:'MKBTPDRowId',title:'属性内容表id',width:80,hidden:true,resizable:false},
								{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,resizable:false,
									sorter:function (a,b){  
										if(a.length > b.length) return 1;
										else if(a.length < b.length) return -1;
										else if(a > b) return 1;
										else return -1;
									}
								},
								{field:'MKBTRowId',title:'RowId',width:80,hidden:true,resizable:false},
								{field:'MKBTDesc',title:'描述',width:150,resizable:false},
								{field:'MKBTCode',title:'代码',width:150,resizable:false}
							]];
                        //列表datagrid
					var mygrid = $HUI.datagrid("#listterm"+j,{
						url:$URL,
						queryParams:{
							ClassName:"web.DHCBL.MKB.MKBTermProDetail",
							QueryName:"GetSellistTermList",
							property:propertyid
						},
						columns:columns,
						pagination: false,   //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏
						idField:'MKBTRowId', 
						rownumbers:true,    //设置为 true，则显示带有行号的列。
						fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
						remoteSort:false,  //定义是否从服务器排序数据。true
						sortName : 'MKBTPDSequence',
						sortOrder : 'asc',
						scrollbarSize :0
                    }); 
                }
            }
            else if(type == "SS"){//---引用起始节点---石萧伟
				iframhtml ='<table id="streeterm'+j+'" data-options="fit:false,border:false"></table>';
				$("#div"+j).append(iframhtml);
				$HUI.tree('#streeterm'+j,{
					url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSourseSingleTermJson&property="+propertyid,
					lines:true,  //树节点之间显示线条
					autoSizeColumn:false,
					checkbox:false,
					id:'id',//这里的id其实是所选行的idField列的值
					cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作		
					animate:false,   //是否树展开折叠的动画效果
					onLoadSuccess:function(data){
					},
					onBeforeExpand:function(node){
						$(this).tree('expandFirstChildNodes',node)
					},
					onContextMenu: function(e, node){
						e.preventDefault();		
					}
						
				});								
			}
			else{
                $("#div"+j).append("");
            }
             
            count++;  //记录属性个数
         }
       
         //$("#head_h").append(deschtml);
         moreCount = function(id){
            setTimeout(function(){$('html,body').animate({scrollTop: $("#"+id).offset().top}, 500);},100) //滚动效果
            //document.getElementById("more").scrollIntoView(true)  //跳转效果
         }   
         $("#linktab").after("<div id='countheight' style='display:block;margin-top:10px;margin-left:50px;width:95%;overflow:hidden;border:1px solid #C0C0C0;border-radius:4px'><div style='float:left;width:186px;height:170px;background-color:#f4f6f5'><div id='more' style='font-size:24px;font-weight:400;text-align:center;line-height:170px;border-right:1px solid #C0C0C0'>目录</div></div><div style='min-height:35px;padding-left:20px;float:left;width:75%'><ul style='list-style:none;padding:10px;'>"+ahtml+"</ul></div></div>");
         if(count==0){
             $("#countheight").css("display","none")
             $("#countheight").after("<div id='nulldiv' style='height:500px'></div>")
         }
        // $("#countheight").css('height', (Math.ceil(count/5)*30+30)+'px');
             //实例化 一定要在动态添加元素后 立刻实例化 否则遍历不到新添加的元素
        setTimeout(function(){directoryNav = new DirectoryNav($("h2,h3"),{
            scrollTopBorder:300 //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
        });},1000);  //需要加延时 解决获得高度不准问题
         
    })
  
    
     /*
    * 右侧导航代码 - 页面目录结构导航
    * 滑标动画用的css3过渡动画，不支持的浏览器就没动画效果了
    */
    function DirectoryNav($h,config){
        this.opts = $.extend(true,{
            scrollThreshold:0.2,    //滚动检测阀值 0.5在浏览器窗口中间部位
            scrollSpeed:300,        //滚动到指定位置的动画时间
            scrollTopBorder:300,    //滚动条距离顶部多少的时候显示导航，如果为0，则一直显示
            easing: 'swing',        //不解释
            delayDetection:100,     //延时检测，避免滚动的时候检测过于频繁
            scrollChange:function(){}
        },config);
        this.$win = $(window);
        this.$h = $h;
        this.$pageNavList = "";
        this.$pageNavListLis ="";
        this.$curTag = "";
        this.$pageNavListLiH = "";
        this.offArr = [];
        this.curIndex = 0;
        this.scrollIng = false;
        this.init();
    }

    DirectoryNav.prototype = {
        init:function(){
            this.make();
            this.setArr();
            this.bindEvent();
        },
        make:function(){
            //生成导航目录结构,这是根据需求自己生成的。
            $("body").append('<div id="directory-navbefore"><div class="directory-nav" id="directoryNav"><aside class="directory-scroll"><ul></ul></aside><span class="cur-tag"></span><span class="c-top"></span><span class="c-bottom"></span><span class="line"></span></div></div>');
            var $hs = this.$h,
                $directoryNav = $("#directoryNav"),
                temp = [],
                index1 = 0,
                index2 = 0;
            $hs.each(function(index){
                var $this = $(this),
                text = $this.text();
                var texttool=text;
				(text.length>7)?text=text.substring(0,6):text;
                if(this.tagName.toLowerCase()=='h2'){
                    index1++;
                    if(index1>18) 
                    {
                      
                        $("#directoryNav").append('<li class="l1"><span class="c-dot"></span><a id="moreend">'+"更多目录"+'</a></li>');
                        return false;
                        
                    }
                    if(index1%2==0) index2 = 0;
                    temp.push('<li class="l1"><span class="c-dot"></span>'+index1+'. <a class="l1-text" title="'+texttool+'">'+text+'</a></li>');
                }else{
                    index2++;
                    temp.push('<li class="l2">'+index1+'.'+index2+' <a class="l2-text">'+text+'</a></li>');

                }
            });
            $directoryNav.find("ul").html(temp.join(""));
            $("#moreend").click(function(e){
                $('html,body').animate({scrollTop: $("#more").offset().top}, 500); //滚动效果
                return false;  //
               //document.getElementById("more").scrollIntoView(true)  //跳转效果
                })
            //设置变量
            this.$pageNavList = $directoryNav;
            this.$pageNavListLis = this.$pageNavList.find("li");
            this.$curTag = this.$pageNavList.find(".cur-tag");
            this.$pageNavListLiH = this.$pageNavListLis.eq(0).height();

            if(!this.opts.scrollTopBorder){
                this.$pageNavList.show();
            }
        },
        setArr:function(){
            var This = this;
            this.$h.each(function(){
                var $this = $(this),
                    offT = Math.round($(this).offset().top);
                This.offArr.push(offT);
            })  
        },
        posTag:function(top){
            this.$curTag.css({top:top+'px'});
        },
        ifPos:function(st){
            var offArr = this.offArr;
            //console.log(st);
            var windowHeight = Math.round(this.$win.height() * this.opts.scrollThreshold);
            for(var i=0;i<offArr.length;i++){
                if((offArr[i] - windowHeight) < st) {
                    var $curLi = this.$pageNavListLis.eq(i);
                    //console.table($curLi.position())
                     if(!$.isEmptyObject($curLi.position())){
                            tagTop = $curLi.position().top;
                     }
                    $curLi.addClass("cur").siblings("li").removeClass("cur");
                    this.curIndex = i;
                    this.posTag(tagTop+this.$pageNavListLiH*0.5);
                    //this.curIndex = this.$pageNavListLis.filter(".cur").index();
                    this.opts.scrollChange.call(this);
                }
            }
        },
        bindEvent:function(){
            var This = this,
                show = false,
                timer = 0;
            this.$win.on("scroll",function(){
                var $this = $(this);
                clearTimeout(timer);
                timer = setTimeout(function(){
                    This.scrollIng = true;
                    if($this.scrollTop()>This.opts.scrollTopBorder){
                        if(!This.$pageNavListLiH) This.$pageNavListLiH = This.$pageNavListLis.eq(0).height();
                        if(!show){
                            This.$pageNavList.fadeIn();
                            show = true;
                        }
                        This.ifPos( $(this).scrollTop() );
                    }else{
                        if(show){
                            This.$pageNavList.fadeOut();
                            show = false;
                        }
                    }
                },This.opts.delayDetection);
            });

            this.$pageNavList.on("click","li",function(){
                var $this = $(this),
                    index = $this.index();
                    //alert($("#h13").offset().top)
                    //alert(This.offArr[index])
                This.scrollTo(This.offArr[index]);
            })
        },
        scrollTo: function(offset,callback) {
            var This = this;
            $('html,body').animate({
                scrollTop: offset
            }, this.opts.scrollSpeed, this.opts.easing, function(){
                This.scrollIng = false;
                //修正弹两次回调 
                callback && this.tagName.toLowerCase()=='body' && callback();
            });
        }
    };
    
    
    //文献部分 id='docnum'  更改展示形式20200206
   /*var listHtml=$.m({ClassName:'web.DHCBL.MKB.MKBEncyclopedia',MethodName:'RelationDocHtml',rowid:termdr},false);
   relationdochtml="<div style='padding-left:2px;width:99.8%'><table><tbody>"+listHtml+"</tbody></table></div>";
   $("#relationdoc").append(relationdochtml);*/
   
	var deschtml = ""
	deschtml1="<div class='doccontent' style='display:block;'><h1><div style='border-left:#4F9CEE solid 12px;height:28px;width:1%;display:block;margin-left:0;float:left;display:inline-block;'></div><div style='margin:10px 0 0 35px;width:83%;height:28px;background:url(../scripts/bdp/framework/imgs/paraTitle-line.png);background-position-y:4px;'><div style='padding-right:15px;font-size:16px;font-weight:400;background-color:#FFFFFF;float:left;width:auto;display:inline-block;'>所有文献</div></div></h1></div>";
	$("#relationdoc").append(deschtml1);
	$("#relationdoc").append('<div id="doclay" style="width:'+document.body.clientWidth*0.85+'px;height:1000px;padding-left:50px;" border="false"><table id="doc1" data-options="fit:true"  border="true" ></table></div><p style="padding-left:50px"><u>感谢中国医学科学院医学信息研究所给予的文献指导，文献引用自国家卫健委及各医学出版商相关内容。</u></p>')
	$('#doclay').panel();
	var docdata = $.m({ClassName:'web.DHCBL.MKB.MKBKLMappingDetail',MethodName:'EncyclopediaDocInfo',Exp:termdr,Classify:""},false);
	var doclength = 0
	var docdata1 =	[]
	if (docdata!="")
	{
		if(docdata.indexOf("[A]")>-1){
			var docarr = docdata.split("[A]")
			 doclength = docarr.length
			for(var i = 0;i<docarr.length;i++){
				docdata1.push(eval('(' + docarr[i] + ')'))
			}
			
		}else{
			docdata1.push(eval('(' + docdata + ')'))
			doclength = 1
		}
	}
	setTimeout(function(){
		$('#docnum').html('文献('+doclength+')')
		
	    var doccolumns =[[
	        {field:'DocDesc',title:'文献名称',sortable:true,width:100},
	        {field:'DocPath',title:'路径',hidden:true,width:50},
	        {field:'DocRowId',title:'RowId',hidden:true,width:50},
	        {field:'desc1',title:'预览',width:20,sortable:true,
	            formatter:function(value, row, index){  
	                var btn = '<a href="#"  id="[A]'+row.DocPath+'" class="preview" style="border:0px;cursor:pointer">预览</a>';  
	                return btn;  
	            } 
	        },
	        {field:'desc2',title:'下载',width:20,sortable:true,
	            formatter:function(value, row, index){  
	                var btn = '<a href="#" id="[B]'+row.DocPath+'"  class="download load" style="border:0px;cursor:pointer">下载</a>';  
	                return btn;  
	            } 
	        }
	    ]];
	    var docgrid = $HUI.datagrid("#doc1",{
	        url:$URL,
	        columns: doccolumns,  //列信息
	        pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        //pageSize:PageSizeMain,
	        //pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	        singleSelect:true,
	        remoteSort:false,
	        idField:'DocRowId',
	        bodyCls:'panel-header-gray' ,
	        rownumbers:true,    //设置为 true，则显示带有行号的列。
	        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	        data:docdata1
	    })
	    $("#relationdoc .preview").click(function(e){
	       //var path=$(this).parent().text();
	       var path = $(this).attr("id").split("[A]")[1]
	       previewFile(path);

	   })
	      $("#relationdoc .download").click(function(e){
	       //var path=$(this).parent().text();
	       var path = $(this).attr("id").split("[B]")[1]
	      // alert(path)
	       DownLoadFile(path);
	   })

	},1000)

         
      //点击下载按钮
    function DownLoadFile(fileName)
    {
        if(fileName)
        {
	        $.m({ClassName:"web.DHCBL.BDP.BDPVisitLog",MethodName:"SaveData",SaveDataStr:session['LOGON.SITECODE']+'&%D&%&%&%'+fileName},false);
            var isExists=$.m({ClassName:"web.DHCBL.BDP.BDPUploadFile",MethodName:"IsExistsFile",filePath:"scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName},false);
            var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName;
            if(isExists==1 && fileName!="")
            {
                $(".load").attr("href",filepath);
                $(".load").attr("download",fileName);
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
                        //alert("此浏览器使用另存下载");
                        $(".load").attr("target","_blank");
                    }
                }
            }else{
                  /*$.messager.show
                  ({ 
                      title: '提示消息', 
                      msg: '该文件不存在！', 
                      showType: 'show', 
                      timeout: 1500, 
                      style: { 
                      right: '', 
                      bottom: ''
                    } 
                }); */
                $.messager.popover({msg: '该文件不存在！',type:'alert'});   
            }       
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
    //点击预览按钮
    function previewFile(fileName)
    {
        if(fileName)
        {
	        $.m({ClassName:"web.DHCBL.BDP.BDPVisitLog",MethodName:"SaveData",SaveDataStr:session['LOGON.SITECODE']+'&%R&%&%&%'+fileName},false);
            var fileType = fileName.split(".")[(fileName).split(".").length-1];
            var PDFisExists=$.m({ClassName:"web.DHCBL.BDP.BDPUploadFile",MethodName:"IsExistsFile",filePath:"scripts\\bdp\\MKB\\Doc\\Doc\\"+fileName.replace(fileType,"pdf")},false);
            if(PDFisExists==1)
            {
                //var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
                var filepath = "../../../Doc/Doc/"+fileName.replace(fileType,"pdf");
                var previewWin=$("#win").window({
						width:$(window).width()*9.7/10,
						height:$(window).height()*9/10,
						//top:document.body.scrollTop+document.documentElement.scrollTop, 
						modal:true,
						title:fileName,
						minimizable:false,
						maximizable:false,
						collapsible:false
                        
                    });
				 $('#win').html('<iframe src="../scripts/bdp/MKB/MKP/pdfjs/web/viewer.html?file='+encodeURIComponent(filepath)+'"  style="height:99.2%;width:99.6%"></iframe>');

				
                 $("#win").window('center');
                  previewWin.show();
                   
	              $('html,body').animate({scrollTop: $(".window-header").offset().top}, 500); //滚动效果
	            
					
                  
            }else{
                  /*$.messager.show({ 
						title: '提示消息', 
						msg: '不存在pdf预览文件！', 
						showType: 'show', 
						timeout: 1000, 
						style: { 
						right: '', 
						bottom: ''
                    } 
                }); */
                $.messager.popover({msg: '不存在pdf预览文件！',type:'alert'});   
            }       
        }else{
            $.messager.alert('错误提示','请先选择一条记录!',"error");
        }
    }
	/*$("#changeview").tooltip({
		content:'<span>图谱百科切换</span>',
		position: 'left', //top , right, bottom, left
		onShow: function(){    
			$(this).tooltip('tip').css({
				backgroundColor: '#666', 
				borderColor: '#666'
			});   
		}
	})*/
	
})