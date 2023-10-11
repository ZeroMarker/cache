/// Excel导入导出工具类
var INSUExcelTool=(function(){
	
	//私有静态方法----------------------------(不对外发布的方法)-----------------------------------
	//创建导入导出提示框 
    function _InitProgress(InitMsg){
	    if ((InitMsg=="")||(InitMsg=="undefined")) {InitMsg="正在导入中..."}
    	if($('#loadLable').length!=0){
			$('#loadLable').html(InitMsg)  //初始化下
		}
		if($('#loadLable').length==0){
			$loadLable=$("<div id='loadLable' style='display:none;position:fixed;border-style: solid;border-width:1px;border-color:#46A3FF;background-color:#FFFFDF;width:400px;height:60px; z-index:10000;top:-200px;left:-100px;right:0px;bottom:0px;margin:auto;text-align:center;padding:20px;'>"+InitMsg+"</div>");
			$("body").append($loadLable);
		};
	}
	///打开文件并获取excel数据
	function _OpenAndGetExcelDataArr(){  //获取excel数据
		//var _this=this 
		//_this.InitProgress();  //初始化导出提示框
		return new Promise(function(resolve, reject) {
			$('#FileWindowDiv').empty();
			$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
			$("table").append($FileWindowDiv);
			$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
			$("#FileWindowDiv").append($FileWindow);
			//$('#FileWindow1').val("");
	 		//实现消息框的阻塞执行		
	 		$('#FileWindow').select();
			if (!!window.ActiveXObject || "ActiveXObject" in window){  //ie支持click
				   	_InitProgress("数据导入初始化...");  //创建提示框  //ie 在click前创建 否则可能渲染不出来
					$('#loadLable').show();
					$('#FileWindow').click();  
					_GetExcelData().then(function(data){	
						resolve(data) 
					})

    		}else {   //谷歌浏览器需要添加到onchange 事件	
    			$('#FileWindow').click();  
    			$("#FileWindow").change(function(){
	    			_InitProgress("数据导入初始化...");  //创建提示框  在click后创建 否则取消选择后关闭不了
					$('#loadLable').show();
	    			_GetExcelData().then(function(data){
    				resolve(data) 
    				})
    			})	
    		} 		
    	}) 	
	}
	
	///获取excel数据
	function _GetExcelData(){
		return  new Promise(function(resolve, reject) {	
			$('#loadLable').html("数据读取中，请稍等.....")  //初始化下
			var FilePath=$('#FileWindow').val();
			//$.messager.alert("提示",FilePath)	
			if(!FilePath){
				$('#loadLable').hide()
				return;
			}
			var suffix=FilePath.substring(FilePath.lastIndexOf(".")+1,FilePath.length);
			if((suffix!="xls")&&(suffix!="xlsx")){
				$.messager.alert("提示","文件类型不正确");
				$('#loadLable').hide()
				return 
			}
			var files = $('#FileWindow')[0].files;	        
			var fileReader = new FileReader();  //重新 readAsBinaryString 	 	
	   	 	fileReader.readAsArrayBuffer(files[0]);// 以数组形式
	   		//fileReader.readAsBinaryString(files[0]);// 以二进制方式打开文件  //ie不支持
	   		var fixdata=function(data) { //文件流转BinaryString  //匿名方法   解决 xls 读取进异常的问题 bug
                var o = "",w = 10240;
                for(var l = 0; l < data.byteLength / w; ++l) {
                	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
                }
                o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
                return o;
            }

	   		fileReader.onload = function(ev) {
	   			try {	               
	   				var data = ev.target.result;
	         		var workbook = XLSX.read(btoa(fixdata(data)), { type: 'base64'}),  //binary
	         		persons=[];
	         	} catch (e) {
	         		return $.messager.alert('文件类型不正确!');
	         	}
				// 遍历每张表读取
				for (var sheet in workbook.Sheets) {
					if (workbook.Sheets.hasOwnProperty(sheet)) {
						worksheet = workbook.Sheets[sheet]['!ref'];
						persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet], {header:1,defval:""}));  //转成数组和空字符处理
        				break ;  //只取第一张表
        			}
        		}
        		resolve(persons) 
        	}
        })
	}
	
	/**
	  shy 
	  二维数组或者json数组导出excel 
	  Data 格式 json数组--> [{"tset":"1","shy":"2"},{"tset":"1","shy":"2"}]
	 二维数组-->  [[1,2,3,4,5],[2,3,45,6,5]]
	 */
	 function _Array2Excel(Data,fileName){
	 	if((Data=="")||(Data==null)||(!(Data instanceof Array))||((!(Data[0] instanceof Array))&&(!(typeof Data[0] == 'object'  )))){
	 		$.messager.alert("提示","需导出excel的数组格式有误,必须是二维数组或者是json数组");
	 		return ;
	 	}
	 	var wopts = {bookType: 'xlsx',bookSST: false,type: 'binary'};
	 	var workBook = {SheetNames: ['Sheet1'],Sheets: {},Props: {}};
   		 //1、XLSX.utils.json_to_sheet(data) 接收一个对象数组并返回一个基于对象关键字自动生成的“标题”的工作表，默认的列顺序由使用Object.keys的字段的第一次出现确定
    	//2、将数据放入对象workBook的Sheets中等待输出
    	var mySkipHeader={
    		skipHeader:false
    	}
    	if(Data[0] instanceof Array){
	   		 mySkipHeader.skipHeader=true //如果是普通数组，第一行行号去掉
	   	}
	   	workBook.Sheets['Sheet1'] = XLSX.utils.json_to_sheet(Data,mySkipHeader)

		var changeData=function(s) {  //内部类方法
    		//如果存在ArrayBuffer对象(es6) 最好采用该对象
    		if (typeof ArrayBuffer !== 'undefined') {
      			//1、创建一个字节长度为s.length的内存区域
      			var buf = new ArrayBuffer(s.length);
      			//2、创建一个指向buf的Unit8视图，开始于字节0，直到缓冲区的末尾
      			var view = new Uint8Array(buf);
    	  		//3、返回指定位置的字符的Unicode编码
    	  		for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
    	  			return buf;
    	  	} else {
    	  		var buf = new Array(s.length);
    	  		for (var i = 0; i != s.length; ++i) buf[i] = s.charCodeAt(i) & 0xFF;
    	  			return buf;
    	  	}
    	  }
		var SaveAs=function(obj, fileName) {//当然可以自定义简单的下载文件实现方式
			$('#loadLable').hide();    //执行完成后台代码后，关闭显示框
			if (window.navigator && window.navigator.msSaveOrOpenBlob) {
				
				window.navigator.msSaveOrOpenBlob(obj, fileName ? fileName + '.xlsx' : new Date().getTime() + '.xlsx');
			}else{
				var tmpa = document.createElement("a");
				tmpa.download = fileName ? fileName + '.xlsx' : new Date().getTime() + '.xlsx';
    			tmpa.href = URL.createObjectURL(obj); //绑定a标签
    			tmpa.click(); //模拟点击实现下载
    			setTimeout(function () { //延时释放
      				URL.revokeObjectURL(obj); //用URL.revokeObjectURL()来释放这个object URL
      			}, 100);
    		}
    	}
    	
    	SaveAs(new Blob([changeData(XLSX.write(workBook, wopts))], { type: 'application/octet-stream' }),fileName)

    }
	
	
	/// 功能说明:获取需要导出的数据，并导出到Excel中
	function _ExcelExport(DataSourceType, ClassName, MethodName, InputPam){
		_InitProgress("数据获取中，请稍等.....");
		$('#loadLable').show();
		
		//获取总的明细数据
		var url=APP_PATH+"/com.ImportOrExportCtl/ExcelExportAjaxN";
		$.post(url,{
			DataSourceType:DataSourceType
			,ClassName:ClassName
			,MethodName:MethodName
			,InputPam:InputPam
		},function(data){
			if(data.Status>0){
				var DataRtnInfo=data.DataRtnInfo;       //导出数据信息  格式:1数据数量^2数据key^3global名称及前缀
				var RtnArr=DataRtnInfo.split("^");
				var ALLSize=RtnArr[0];                  //数据数量
				var ExportDataID=RtnArr[1];             //数据key
				var DataGlobalName=RtnArr[2];           //global名称及前缀
				var rows=100;                //每行显示数目
				var page=1;                  //第一页
				var OutData="";
				
				$('#loadLable').html(data.InfoMsg);        //导出进度展示
				_ExportDataByPage(rows, page, DataSourceType, ALLSize, ExportDataID, DataGlobalName, OutData);   //按页导出数据
			}else{
				$.messager.alert('温馨提示',data.ErrMsg);
				$('#loadLable').hide();
			}	
		},"json");
	}
	
	/// 功能说明：大量数据分页导出
	function _ExportDataByPage(rows, page, DataType, ALLSize, ExportDataID, DataGlobalName, OutData){
		
		//获取总的明细数据
		var url=APP_PATH+"/com.ImportOrExportCtl/GetExportRowData";
		$.post(url,{
			rows:rows
			,page:page
			,DataType:DataType
			,ALLSize:ALLSize
			,ExportDataID:ExportDataID
			,DataGlobalName:DataGlobalName
		},function(data){
			if(data.Status>0){
				var EndPageFlg=data.EndPageFlg;            //是否为最后一页数据标志
				$('#loadLable').html(data.InfoMsg);        //导出进度展示
				if(OutData==""){
					OutData=data.RowsArr;
				}else{
					OutData=OutData+","+data.RowsArr;
				}
				
				if(EndPageFlg!="1"){
					page=page+1;      //当前页数+1作为下次查询的页数
					_ExportDataByPage(rows, page, DataType, ALLSize, ExportDataID, DataGlobalName, OutData);   //按页导出数据
				}else{
					_InitProgress("数据生成完毕，正在生成excel中，请不要关闭浏览器.....");
					 setTimeout(function(){   //ie下渲染可能效果出不了，这儿强制渲染下
						_Array2Excel(eval("["+OutData+"]"),"tmpExcelData");
						$('#loadLable').hide();
					 },50)
				}
			}else{
				$.messager.alert('温馨提示',data.ErrMsg);
				$('#loadLable').hide();
			}	
		},"json");
	}
	
	/// 功能说明：二维数据的数据循环导入系统中
	/// 入参说明：ClassName     --> 保存行数据的类
	///           MethodName    --> 保存行数据的方法
	///           GlobalDataFlg --> 保存到临时global中的标志 1 临时global数据 0 非临时global数据(此时类和方法名称必须传入)
	///           ExtStrPam     --> 扩展参数
	///           UserDr        --> 导入的操作员
	///           Rows          --> 二维数据数据
	///           RecIndex      --> 数组的第几行数据(序号从1开始)
	///           ErrMsg        --> 错误消息
	///           GlobalDataKey --> 导入数据记录错误的globalkey
	///           SumNum        --> 成功行数
	///           ErrNum        --> 失败行数
	///           StartRow      --> 从哪一行开始导入(不传则从第二行开始导入)
	function _ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, UserDr, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun){
		
		var RowNums=Rows.length;      //数组总数目
		if ((RowNums<1)||(RecIndex>RowNums)) {
			$('#loadLable').hide();
			return 0;
		}
		
		var RowIndex=RecIndex-1;      //数组序号 比行数据的序号少一个
		var RowData=Rows[RowIndex];   //行数据(一维数组)
		var ColNums=RowData.length;   //列数目
		
		var ImportNums=RowNums-(StartRow-1)   //有效导入行数
		var ImportIndex=RecIndex-(StartRow-1) //导入数据序号
		var BaseImportInfo="本次导入的数据共计"+ImportNums+"行"+ColNums+"列.";
		
		/// 组织行数据格式 为 上箭头分割的数据字符串
		var RowDataInfo="";
		var ColVal="";
		for (var colIndex=0; colIndex<ColNums; colIndex++){
			ColVal=RowData[colIndex];   //列数据
			if(colIndex==0){
				RowDataInfo=ColVal;
			}else{
				RowDataInfo=RowDataInfo+"^"+ColVal;
			}
		}
		
		/*
		if(RowDataInfo==""){
			$('#loadLable').hide();
			return 0;
		}
		*/
		
		//alert("RowDataInfo="+RowDataInfo);
		
		var RowImportMsg=BaseImportInfo+"<br/>"+"第"+ImportIndex+"行导入开始..."
		$('#loadLable').html(RowImportMsg)
		
		var url=APP_PATH+"/com.ImportOrExportCtl/ExcelImportAjaxN";
		$.post(url,{
			ClassName:ClassName
			,MethodName:MethodName
			,RowIndex:RecIndex
			,RowDataInfo:RowDataInfo
			,UserDr:UserDr
			,GlobalDataFlg:GlobalDataFlg
			,ExtStr:ExtStrPam
			,GlobalDataKey:GlobalDataKey
		},function(data){
			var ResultDesc="";
			if(data.Status=="-100"){                //发生不能继续往下走的错误时,停止循环
				$('#loadLable').hide();
				$.messager.alert("温馨提醒",data.ErrMsg+"第"+ImportIndex+"行"+RowDataInfo);
				return 0;
			}
			
			if(data.Status>0){
				var GlobalDataKey=data.GlobalDataKey;       //数据key
				SumNum=SumNum+1;    //成功数量+1
				ResultDesc="成功";
			}else{
				ErrNum=ErrNum+1     //失败数量+1
				if(ErrMsg==""){
					ErrMsg=data.ErrMsg;
				}else{
					ErrMsg=ErrMsg+"\n"+data.ErrMsg;
				}
				ResultDesc="失败";
			}
			
			RowImportMsg=BaseImportInfo+"<br/>"+"第"+ImportIndex+"行导入完成["+ResultDesc+"].";
			$('#loadLable').html(RowImportMsg)
			
			//判断是否为最后一行数据
			if(RecIndex==RowNums){
				$('#loadLable').hide();
				var ResultMsgInfo=BaseImportInfo+"成功"+SumNum+"行,失败"+ErrNum+"行.";
				$.messager.alert('提示',ResultMsgInfo);

				
				//有回调函数的时候,调用回调函数，入参为返回值
				if(typeof(RtnFun)!='undefined'){
					RtnFun();
				}
			}else{
				RecIndex=RecIndex+1   //不是最后一行数据的时候递归调用导入数据
				_ImportRowsData(ClassName, MethodName, GlobalDataFlg, ExtStrPam, UserDr, Rows, RecIndex, ErrMsg, GlobalDataKey, SumNum, ErrNum, StartRow, RtnFun);  //导入下一行数据
			}
				
		},"json");
		
		
	}
	
	//创建类方法
	function _tool(){
	}
	
	//构建原型方法(对外使用方法)====================================================================================
	_tool.prototype={
		
		/// 功能说明: Excel数据导入共通方法
		/// 入参说明：ClassName     --> 保存行数据的类
		///           MethodName    --> 保存行数据的方法
		///           GlobalDataFlg --> 保存到临时global中的标志 1 临时global数据 0 非临时global数据(此时类和方法名称必须传入)
		///           ExtStrPam     --> 扩展参数
		///           UserDr        --> 导入的操作员
		///           StartRow      --> 从哪一行开始导入(不传则从第二行开始导入)
		///           RtnFun        --> 回调函数
		/// 特别说明：导入行数据的方法定义格式[SaveImportData(RowDataInfo As %String, UserDr As %String, ByRef info As %String, ExtStr As %String)]
		ExcelImport:function(ClassName, MethodName, GlobalDataFlg, ExtStrPam,UserDr, StartRow, RtnFun){
			var ArgLen=arguments.length;         //参数个数
			if(ArgLen<3){
				$.messager.alert('温馨提示',"参数个数不足,请核对!");
				return 0;
			}
			if(GlobalDataFlg=="0"){   //非临时global必须传入类和方法名称
				if((ClassName=="")||(MethodName=="")){
					$.messager.alert('温馨提示',"非临时global的情况下,需要传入类名和方法名.");
					return 0;
				}
			}
			
			//设置默认值
			if(ArgLen<4){ ExtStrPam=""; }
			if(ArgLen<5){ UserDr=""; }
			if(ArgLen<6){ StartRow=2; }
			if(StartRow==""){ StartRow=2}; //如果传成空 

			_OpenAndGetExcelDataArr().then(function(dataArr){   //获取excel数据
				_ImportRowsData(ClassName,MethodName,GlobalDataFlg, ExtStrPam, UserDr, dataArr, StartRow, "", "", 0, 0, StartRow, RtnFun)
			})
		},
		
		/// 功能说明: query、临时global、临时global数据导出Excel的共通方法
		/// 入参说明：第一个参数 --> 查询数据源类型(0 query查询结果 1 global列表数据 2 global^分割的数据 )
		///           第二个参数 --> 查询数据的类名称
		///           第三个参数 --> 查询数据的方法名称或者query名称
		///           第四个之后的参数 --> 按顺序传入查询方法的参数
		/// 特别说明：如果返回值是临时global数据标题保存在如右的格式中 s:index>0 ^TMPINSUQC("RuleLocGrpInfo", RuleLocGrpID, "title")=$lb("1","2","3")
		///           在title节点中保存
		///           使用举例参照[js/dictool/reprulelocgroup.js]
		ExcelExport:function(){
			var ArgLen=arguments.length;         //参数个数
			if (ArgLen<4) {
				$.messager.alert('温馨提示',"调用参数个数不正确,请联系开发人员!");

				return 0;
			}
			
			var DataSourceType=arguments[0];     //查询数据源类型(0 query查询结果 1 列表数据 2 ^分割的数据 )
			var ClassName=arguments[1];          //查询数据的类名称
			var MethodName=arguments[2];         //查询数据的方法名称或者query名称
			var InputPam="";                     //方法的或者query的参数拼串(按照方法执行的参数顺序拼串 用","号分割分割各个参数)
			var ArgPamVal="";
			//组织查询参数
			for(var ArgIndex=3; ArgIndex<ArgLen; ArgIndex++){
				ArgPamVal=arguments[ArgIndex];
				if(ArgIndex==3){
					InputPam=ArgPamVal
				}else{
					InputPam=InputPam+","+ArgPamVal;
				}
			}
			_ExcelExport(DataSourceType, ClassName, MethodName, InputPam);
		}
		
		/// 功能说明: 导出json数组或者js的二维数组
		/// 入参说明：JsonArrr --> json数组或者二维数组
		/// 使用场景: 导出datagridview的当前页数据
		///           json对象数组例子：[["PatAdmDr":"1","Patname":"测试1","patNo":"3"],["PatAdmDr":"2","Patname":"测试2","patNo":"2"]]
		///           二维数组例子    : [["\"1"\","2","3"],["4","5","6"]] 
		,ExcelExportOfArrData:function(Data,Header,FileName){
			 //JsonArrr.unshift();
			 var DataO=eval(Data);
			 var Header= Header || "";
			 if (Header!=""){
			  DataO.unshift(Header);
			 }
			 var FileName = FileName || "tmpExcelArrData"
			_Array2Excel(DataO,FileName);
			 if (Header!=""){
			  DataO.shift();
			 }
		}
		
	}
	
	//返回类
	return _tool;
})()