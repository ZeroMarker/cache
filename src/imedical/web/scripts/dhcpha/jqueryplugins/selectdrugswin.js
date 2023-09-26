
   /*
   LiangQiang 2014-08-08
   定制弹出Div窗体,默认是窗品项目列表
   */
   var CreatMyDiv=function (input,tarobj,mydivid,mydivw,mydivh,mytblid,mycols,mydgs,mydgid,mydesc,fn)
	{
		this.input=input;　//入参
		this.tarobj=tarobj; //目标源
		this.mydivid=mydivid; //
		this.mydivw=mydivw;
		this.mydivh=mydivh;
		this.mytblid=mytblid;
		this.mycols=mycols;
		this.mydgs=mydgs;
		this.fn=fn;
		


	}

	CreatMyDiv.prototype={ 

		init:function(){
			  
			  var input=this.input;
			  var tarobj=this.tarobj;
			  var mydivid=this.mydivid;
			  var mydivw=this.mydivw;
			  var mydivh=this.mydivh;
			  var mytblid=this.mytblid;
			  var mycols=this.mycols;
			  var mydgs=this.mydgs;
			  var fn=this.fn;

			  var rowIndex="";

              if((input.length)==0){
				   return;
			   }
	
               RemoveMyDiv();
	
               $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
			   //$(document.body).append('<div id="drugsfollower" style="width:650px;height:335px;border:1px solid #E6F1FA;position:absolute"></div>') 
			   $("#"+mydivid).append('<div id='+mytblid+'></div>');

               var mydiv=$("#"+mydivid);
               /*
               var dh=mydiv.height();
			   var eh=event.clientY;
			   var bh=$(document.body).height();
	
			   if ((dh+eh)>bh)
			   {
				   h=eh-dh;
			   }else{
					 h=eh ;
			   }

			   var dw=mydiv.width();
			   var ew=event.clientX;
			   var bw=$(document.body).width();

			   if ((dw+ew)>bw)
			   {
				   w=ew-dw;
			   }else{
					 w=ew ;
			   }

			   */
			 
			  mydiv.show();
			  //mydiv.css("left",document.body.scrollLeft+w+50); 
			  //mydiv.css("top",document.body.scrollLeft+h+10);  grid用
			  //mydiv.css("top",jQuery(obj).offset().top + jQuery(obj).outerHeight());
			  
			  mydiv.css("left",tarobj.offset().left);
			  mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());


			  if (mycols=='')
			  {
				  	  mycols = [[
						  {field:'InciCode',title:'代码',width:60}, 
						  {field:'InciDesc',title:'名称',width:220}, 
						  {field:'Spec',title:'规格',width:80},
						  {field:'ManfName',title:'厂家',width:80},
						  {field:'PuomDesc',title:'入库单位',align:'center',width:80},
						  {field:'pSp',title:'售价(入库单位)',align : 'right',width:60},  
						  {field:'PuomQty',title:'数量(入库单位)',align:'right',width:60},
						　{field:'BuomDesc',title:'基本单位',align:'center',width:60},
						  {field:'bSp',title:'售价(基本单位)',align : 'right',width:60},
						  {field:'BuomQty',title:'数量(基本单位)',align:'right',width:60},
						  {field:'BillUomDesc',title:'计价单位',align:'center',width:60},
						  {field:'PhcdfDr',title:'PhcdfDr',align:'center',width:60}

					  ]];
			  }
	
			  if (mydgs=='')
			  {
					mydgs = {
						//url: url+'?action=QueryDrugDs&input=lhn',  //csp, 空为null
						url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
						columns: mycols,  //列信息
						pagesize:10,  //一页显示记录数
						table: '#drugsgrid', //grid ID
						field:'InciCode', //记录唯一标识
						params:null,  // 请求字段,空为null
						tbar:null //上工具栏,空为null

					}
			  }

		      var gridobj = new DataGrid(mydgs);
              gridobj.init();

              var mygrid=$("#"+mytblid);
              mygrid.datagrid('getPanel').panel('panel').focus() ;
			
			  mygrid.gridupdown(mygrid);
			  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
				
                switch (e.keyCode) {
                case 13: // enter
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   var PhcdfDr=mygrid.datagrid('getSelected').PhcdfDr ;
				   rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
				   RemoveMyDiv();
				   fn(InciDesc,PhcdfDr);
				   return ;
				   
                case 27:  //Esc
				   RemoveMyDiv();
				   fn('');
				   return;

				}
				


			  })

              
			  mygrid.datagrid('getPanel').panel('panel').blur(function() { 
 

				 if (rowIndex=="")
				 {
					 //alert(1)
					//RemoveMyDiv();
					//fn('');

				 }

				   

				   
			  });


			    //清空
			  function RemoveMyDiv()
			  {
				if($("#"+mydivid).length>0)
				   {
					   $("#"+mydivid).remove(); 
					   $("#"+mytblid).remove(); 
				   }
			  }
              
			  //设置目标获得焦
			  function SetTargetFocus(obj)
			  {
				  obj.focus();
			  }





		}



	}


  
	var ShowWinSelectDrugs= function(input,tarobj,mydivid,mydivw,mydivh,mytblid)
   {
            
			   alert("a")
               if((input.length)==0){
				   return;
			   }
	
               RemoveMyDiv();

               $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
			   //$(document.body).append('<div id="drugsfollower" style="width:650px;height:335px;border:1px solid #E6F1FA;position:absolute"></div>') 
			   $("#"+mydivid).append('<div id='+mytblid+'></div>');

               var mydiv=$("#"+mydivid);
               /*
               var dh=mydiv.height();
			   var eh=event.clientY;
			   var bh=$(document.body).height();
	
			   if ((dh+eh)>bh)
			   {
				   h=eh-dh;
			   }else{
					 h=eh ;
			   }

			   var dw=mydiv.width();
			   var ew=event.clientX;
			   var bw=$(document.body).width();

			   if ((dw+ew)>bw)
			   {
				   w=ew-dw;
			   }else{
					 w=ew ;
			   }

			   */
			 
			  mydiv.show();
			  //mydiv.css("left",document.body.scrollLeft+w+50); 
			  //mydiv.css("top",document.body.scrollLeft+h+10);  grid用
			  //mydiv.css("top",jQuery(obj).offset().top + jQuery(obj).outerHeight());
			  
			  mydiv.css("left",tarobj.offset().left);
			  mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());
	
			  var drugsgridcols = [[
				  {field:'InciCode',title:'代码',width:60}, 
				  {field:'InciDesc',title:'名称',width:220}, 
				  {field:'Spec',title:'规格',width:80},
				  {field:'ManfName',title:'厂家',width:80},
				  {field:'PuomDesc',title:'入库单位',align:'center',width:80},
				  {field:'pSp',title:'售价(入库单位)',align : 'right',width:60},  
				  {field:'PuomQty',title:'数量(入库单位)',align:'right',width:60},
				　{field:'BuomDesc',title:'基本单位',align:'center',width:60},
                  {field:'bSp',title:'售价(基本单位)',align : 'right',width:60},
			      {field:'BuomQty',title:'数量(基本单位)',align:'right',width:60},
				  {field:'BillUomDesc',title:'计价单位',align:'center',width:60}

			  ]];

			  var dgs = {
					//url: url+'?action=QueryDrugDs&input=lhn',  //csp, 空为null
					url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
					columns: drugsgridcols,  //列信息
					pagesize:10,  //一页显示记录数
					table: '#drugsgrid', //grid ID
					field:'InciCode', //记录唯一标识
					params:null,  // 请求字段,空为null
					tbar:null //上工具栏,空为null

				}

		      var gridobj = new DataGrid(dgs);
              gridobj.init();

              var mygrid=$("#"+mytblid);
              mygrid.datagrid('getPanel').panel('panel').focus() ;
			  mygrid.gridupdown(mygrid);
			  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
                switch (e.keyCode) {
                case 13: // enter
				   
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   var rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
				   RemoveMyDiv();
				   fn(InciDesc);
	
				   return
                case 27:
				   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
				   RemoveMyDiv();
				   fn(InciDesc);
				 
				}
				


			  })

			  mygrid.datagrid('getPanel').panel('panel').blur(function() { 
				   
				   RemoveMyDiv();
				   fn(rowid);
				   
			  });
			    //清空
			  function RemoveMyDiv()
			  {
				if($("#"+mydivid).length>0)
				   {
					   $("#"+mydivid).remove(); 
					   $("#"+mytblid).remove(); 
				   }
			  }
              
			  //设置目标获得焦
			  function SetTargetFocus(obj)
			  {
				  obj.focus();
			   }

        


   }

 


 
   



