*将“美对中关税（美进口中出口）.csv"转换成“美对中关税（美进口中出口）.dta"
* 设置工作目录
cd "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配"
* 导入 CSV 文件
import delimited "美对中关税（美进口中出口）.csv", clear
* 保存为 DTA 文件
save "美对中关税（美进口中出口）.dta", replace







**merge**************************************************
*********************************************************

****加载表1（CHINA_Export.dta)****************************
cd "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配"
use "CHINA_Export.dta", clear

* 检查变量类型
describe HS商品编码_HSCd

* 如果变量是数值类型，转换为字符串类型
*gen hs_cd_str = string(HS商品编码_HSCd)

* 截取表1的HS编码为前6位
gen HS6 = substr(HS商品编码_HSCd, 1, 6)

* 保存表1的临时文件
save "CHINA_Export_HS6.dta", replace

* 清空内存
clear

***加载表2(美对中关税（美进口中出口）.dta)*************************
cd "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配"
use "美对中关税（美进口中出口）.dta", clear

* 检查表2的变量名
describe

* 截取表2的productname为前6位
gen HS6 = substr(productname, 1, 6)

* 保存表2的临时文件
save "new_不做hs重复项清洗_美对中关税（美进口中出口）_HS6.dta", replace








***合并数据集***************************************************************************************************************************************************************************
cd "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配"
use "CHINA_Export_HS6.dta", clear
merge m:m HS6 using "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配\new_不做hs重复项清洗_美对中关税（美进口中出口）_HS6.dta"

* 查看合并结果
list if _merge == 3   /* 查看成功匹配的记录 */
list if _merge == 1   /* 查看仅在表1中的记录 */
list if _merge == 2   /* 查看仅在表2中的记录 */

* 保存合并后的数据集
save "不做hs重复项清洗_中国出口_product_tariff_merged_data.dta", replace




******clean _merge列***********************
*******************************************
* 设置工作目录（
cd "D:\tariff_ESG\tariff_data_collection\有效数据\4.8中国出口关税匹配"
use "不做hs重复项清洗_中国出口_product_tariff_merged_data.dta", clear

* 保留匹配成功的项（_merge=3）
keep if _merge == 3

* 保存清洗后的数据
save "中国出口_cleaned_product_tariff_merged_data.dta", replace

count














