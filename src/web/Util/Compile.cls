Class web.Util.Compile Extends %RegisteredObject
{

/// @date 2022-11-02 18:00
/// @author wanghc
/// @other 列出【没有验证登录状态】的csp
/// W ##CLASS(web.Util.Compile).findNotSessionExpired("/csp","8.4")  //查询csp目录下
/// W ##CLASS(web.Util.Compile).findNotSessionExpired("/csp/cdss","8.4") //查询/csp/cdss目录下
ClassMethod findNotSessionExpired(dir = "", type = 8.4)
{
	Set srcpath=##class(ext.util.String).GetPhysicalPath("",dir)
	Set srcpath = ##class(%File).NormalizeDirectory(srcpath)
	Set p=0
	Kill plist
	Set Count = 1
	if ##class(%File).DirectoryExists(srcpath) {
		set file = $zsearch(srcpath_"*.csp")
		While (file '= "") {
			Set filename= ##class(%File).GetFilename(file)
			Set Count = Count+1
			//w file,!
			i ##Class(%File).Exists(file) {
				Set FileObj = ##class(%File).%New(file)
				do FileObj.Open("R")
				if FileObj {
					Set Has=0, CommentLine=0,overwrite=0
					While('FileObj.AtEnd){
						Set line = FileObj.ReadLine()
						if $zcvt(line,"U")[$zcvt("##Class(websys.SessionEvents).SessionExpired()","U"){
							 Set Has=1
							 if (line["//")||(line[";") Set Has=0
						}
						if $zcvt(line,"U")[$zcvt("##Class(ext.websys.SessionEvents).SessionExpired()","U"){
							 Set Has=1
							 if (line["//")||(line[";") Set Has=0
						}
						if $zcvt(line,"U")[$zcvt("<csp:method name=OnPreHTTP arguments="""" returntype=%Boolean>","U"){
							Set overwrite=1
						}
						//if line["</csp:method>" Quit
						Quit:(Has=1)
					}
					B:filename="alloc.chgdepmarkset.hui.csp"
				}
				if overwrite{
					If Has{
						i CommentLine Set p = p+1, plist(p) = filename
					}else{
						s p = p+1, plist(p) = filename
					}
				}else{
					if type<8.4 Set p = p+1, plist(p) = filename
				}
			}
			
			set file = $zsearch("")
		}
	}else{
		w "未找到目录："_srcpath
		Q ""
	}
	W "------"
	zw plist
	q ""
}

/// @date 2022-09-07 20:00
/// @author wanghc
/// @other 宝安人民, 查找未编译的CSP,且可指定是否编译
/// W ##CLASS(web.Util.Compile).findNotComplieCsp("websys")
/// @String pre  开头字母   查询出以pre开头的csp
/// @String type cls|obj|all 对应cls不存的csp列表,对应obj不存在的csp列表，all表示所有csp列表
ClassMethod findNotComplieCsp(pre = "websys", type = "cls")
{
	sET srcpath="E:\Dthealth\app\dthis\web\csp\"
	set srcpath = ##class(%File).NormalizeDirectory(srcpath)
	set p=0
	k plist
	if ##class(%File).DirectoryExists(srcpath) {
		set file = $zsearch(srcpath_pre_"*.csp")
		While (file '= "") {
			Set filename= ##class(%File).GetFilename(file)
			Set pfilename = $p(filename,".",1,$l(filename,".")-1)
			if type="cls"{
				if 0=$d(^oddDEF("csp.csp."_$zcvt(pfilename,"L"))) {
					set p = p+1, plist(p) = pfilename
					w p_"::"_pfilename,!
				}
			}
			if type="obj"{
				if 0=$d(^rINDEX("csp.csp."_$zcvt(pfilename,"L")_".0")) {
					set p = p+1, plist(p) = pfilename
					w p_"::"_pfilename,!
				}
			}
			if type="all"{
				set p = p+1, plist(p) = pfilename
				w p_"::"_pfilename,!
			}
			set file = $zsearch("")
		}
	}else{
		w "未找到目录："_srcpath
		Q ""
	}
	B ;g会编译
	b ;g真会编译了，你确定？
	f j=1:1:p q:j>1000  d
	.d $system.CSP.LoadPage("/imedical/web/csp/"_plist(j)_".csp")
	.w !,j_"--"
	q ""
}

ClassMethod FindObj(namespace, cspName)
{
	if $G(namespace)="" s namespace="DHC-APP"
	s len=$l(cspName,".")
	s suffix=$zcvt($p(cspName,".",len),"L")
	s clsName=""
	if suffix="csp" {
		;csp/dhc.message.csp->csp.csp.dhc.message
		;csp/Timeline/ViewConfig.csp->csp.csp.timeline.viewconfig
		;key/test.csp->csp.key.test
		s clsName="csp."_$zcvt( $tr( $p(cspName,".",1,len-1),"/","."),"L")   
	}elseif suffix="csr" {
		;csr是以文件中的csp:rule name属性来的  中间类为csr.csp.ruleName
		;csp/ADDINS.csr->csr.csp.ADDINS
		;
		
		s clsName=""
	}
	if clsName="" q "-1^不是正确的csp名" //-1 非法csp名字
	

	set count=0
 	Set rs = ##class(%ResultSet).%New("%Library.Routine:RoutineList")
 	Set Spec=clsName_".*.OBJ"
	Set sc=rs.Execute(Spec,1,1,namespace)
	If $$$ISERR(sc) {
		q "-1^"_$system.Status.GetErrorText(sc)	
	}
	s flag=0
 	While (rs.Next()) {
	 	//csp.csp.dhc.message.*.OBJ
	 	//File Name/Ext:Routine Size:Date/Time last modified:Language:
#;		csp.csp.dhc.message.0.OBJ:504:2022-09-07 20:19:07:Cache:
#;		csp.csp.dhc.message.1.OBJ:20352:2022-09-07 20:19:07:Cache:
#;		csp.csp.dhc.message.exectest.0.OBJ:504:2021-05-29 13:19:01:Cache:
#;		csp.csp.dhc.message.exectest.1.OBJ:1760:2021-05-29 13:19:01:Cache:
#;		csp.csp.dhc.message.imageview.0.OBJ:556:2021-05-29 13:19:01:Cache:
#;		csp.csp.dhc.message.imageview.1.OBJ:1500:2021-05-29 13:19:01:Cache:
	 	s objName=rs.GetData(1)
	 	s itemSuffix=$p(objName,clsName,2)   // .0.OBJ;.1.OBJ,.exectest.0.OBJ
	 	continue:$l(itemSuffix,".")'=3  //后面按点分割只有3段才对
		s flag=1
		q
 	}
 	q flag
}

}
