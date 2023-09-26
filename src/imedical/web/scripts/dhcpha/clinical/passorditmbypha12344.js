/*
/Creator:LiangQiang
*/


///检查所有医嘱是否合格
///input:医嘱信息,mode(0,不弹出提示窗口,1,弹出示窗口)
///return:0,合格,>0存在问题﹛
function CheckOrdItmByPha1(input,mode)
{
	var input="" ;

    var ret=tkMakeServerCall("web.DHCSTPHCMADDINST", "CheckAllOrdItm",input);
    
    var tmparr=ret.split("^");
	var cnt=tmparr[0];
	var pid=tmparr[1];

	if(cnt>0){	
	
	          if (mode==1){
		          OpenAdtResultWin(ret);
	          }	    					    
		      
	}
	return cnt 
	
    
}

function CheckOrdItmByPha(input,mode)
{
	return "b"
}



function addCssByLink(url){  
   var doc=document;  
    var link=doc.createElement("link");  
    link.setAttribute("rel", "stylesheet");  
    link.setAttribute("type", "text/css");  
    link.setAttribute("href", url);  
  
    var heads = doc.getElementsByTagName("head");  
    if(heads.length)  
        heads[0].appendChild(link);  
    else  
        doc.documentElement.appendChild(link); 

     
}

function CloseAdtResultWin()
{
      $(function(){
	      
	      
	       $('#PhaResultWin').window('close');
      })
}

function OpenAdtResultWin(input)
{
		if (AdtWinOpen==1){	
        	CloseAdtResultWin();
        	
		}
	
	  	var script=document.createElement("script");  
		script.setAttribute("type", "text/javascript");  
		script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/jquery-1.7.2.min.js");  
		var heads = document.getElementsByTagName("head");
		if(heads.length) 
		{
			 heads[0].appendChild(script); 
		} 
		    
		else  {
			document.documentElement.appendChild(script);
		}
		
	    var script=document.createElement("script");  
		script.setAttribute("type", "text/javascript");  
		script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/jquery.easyui.min.js");  
		var heads = document.getElementsByTagName("head");
		if(heads.length) 
		{
			 heads[0].appendChild(script); 
		} 
		    
		else  {
			document.documentElement.appendChild(script);
		}
	    
	    var css="../scripts_lib/jquery-easyui-1.3.5/themes/default/easyui.css";
	    addCssByLink(css);
        var css="../scripts_lib/jquery-easyui-1.3.5/themes/icon.css";
	    addCssByLink(css);
	    var css="../scripts/dhcpha/css/dhcpha.css";
	    addCssByLink(css);
	    
	    
	    var script=document.createElement("script");  
		script.setAttribute("type", "text/javascript");  
		script.setAttribute("src", "../scripts_lib/jquery-easyui-1.3.5/locale/easyui-lang-zh_CN.js");  
		var heads = document.getElementsByTagName("head");
		if(heads.length) 
		{
			 heads[0].appendChild(script); 
		} 
		    
		else  {
			document.documentElement.appendChild(script);
		}
		


		$(function(){
			
			       
			
					var mydiv=document.createElement("div");
					mydiv.setAttribute("id","PhaResultWin");
	
				    //mydiv.style.width="450px"; 
				    //mydiv.style.height="200px"; 
				    mydiv.style.overflow="hidden";
				    mydiv.title="审核结果";
				    mydiv.closable="false";
				    mydiv.minimizable="false";
				    mydiv.maximizable="false";
				    mydiv.collapsible="false";
					document.body.appendChild(mydiv);

				    //var a="<div>"+"<a id='btn' href='#' class='easyui-linkbutton' >easyui</a>"
                    var a="<div>"
                    var a=a+"<table class='easyui-datagrid'  id='AdtResultGrid'></table>"
					var a=a+"</div>"

					
					document.getElementById("PhaResultWin").innerHTML=a ;
					
					if (AdtWinOpen==0){
											
							$('#AdtResultGrid').datagrid({
		    
					              //title:'123',
								  loadMsg:'',
								  width:436, 
								  //iconCls: 'Attach',
							      height:168,
							      //fit:true,
								  border:false,
								  fitColumns:false,
								  singleSelect:true,
								  idField:'itemid',
								  //treeField:'item', 
								  nowrap: false,
								  striped: true,
								  //showHeader:false,
								  columns:[[ 
								  {field:'opt',title:'',width:20, 
					                   formatter:function(value,row,index){  
                                            if (row.desc==""){
	                                            var a = [];
					                        	a.push("<a href='#' ><span class='Attach' title='药品名称'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;");
					                        	return a; 
                                            }
 
					                    } 
                   				  }, 
								  {field:'itemid',title:'itemid',hidden:true},
								  {field:'item',title:'药品/项目',width:130},
								  {field:'desc',title:'问题描述',width:260},
                                  {field:'flag',title:'管控',hidden:true}

								  ]],
								  
								  rowStyler:function(index,row){    
								    if (row.flag==1){    
								            return 'background-color:pink;';    
								        } 
								        
								    if (row.desc==""){    
								            //return 'color:black;font-weight:bold;';  
								            //return 'font-weight:bold;font-size=108px;';  
								        }    
								    }    

							});
					}
					
					$('#PhaResultWin').window({
	
					        closable:true,
					        shadow:false,
					        width:450,
					        height:200,
					        titile : "审方窗口",
					        onOpen:function()
					        {
						        
						        AdtWinOpen=1 ;

					        },
					        onClose:function()
					        {
						         AdtWinOpen=0 ;
						         $(this).window("destroy");
						         //$('#AdtResultGrid').datagrid('getPanel').panel('destroy');

					        }
					        

			        });
			        
              $('#PhaResultWin').window({left:"500px", top:"0px"});
               
			  reload(input);

		      function reload(input){
			      
			      		var url="dhcpha.clinical.action.csp";
					    var _json = jQuery.param({ "action":"GetOrdItmAdtResult","input": input });
						var request = $.ajax({
							url: url,
							type: "POST",
							async: false,
							data: _json,
							dataType: "json",
							//contentType: "charset=utf-8",
							cache: false,
							success: function (json, textStatus) {
		
									$("#AdtResultGrid").datagrid("loadData",json);
							},
							error: function (XMLHttpRequest, textStatus, errorThrown) { 
								  //alert(XMLHttpRequest.readyState); 
								}
						});
						
						
		      }
             

		            

           

		})
		 
		 

	﹛﹛	 
		 
		 
}


