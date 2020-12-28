import os
import time
import re



listName = ['r_R4311L_p_clip.shp', 'r_R4311L_p_clip.shx', 'r_R4311L_s_clip.cpg', 'r_R4311L_s_clip.dbf', 'r_R4311L_s_clip.prj', 'r_R4311L_s_clip.shp', 'r_R4311L_s_clip.shx', 'r_R4311L_t_clip.cpg', 'r_R4311L_t_clip.dbf', 'r_R4311L_t_clip.prj', 'r_R4311L_t_clip.shp', 'r_R4311L_t_clip.shx', 'r_R4311L_v_clip.cpg', 'r_R4311L_v_clip.dbf', 'r_R4311L_v_clip.prj', 'r_R4311L_v_clip.shp', 'r_R4311L_v_clip.shx', 'r_R4313L_p_clip.cpg', 'r_R4313L_p_clip.dbf', 'r_R4313L_p_clip.prj', 'r_R4313L_p_clip.shp', 'r_R4313L_p_clip.shx', 'r_R4313L_s_clip.cpg', 'r_R4313L_s_clip.dbf', 'r_R4313L_s_clip.prj', 'r_R4313L_s_clip.shp', 'r_R4313L_s_clip.shx', 'r_R4313L_t_clip.cpg', 'r_R4313L_t_clip.dbf', 'r_R4313L_t_clip.prj', 'r_R4313L_t_clip.shp', 'r_R4313L_t_clip.shx', 'r_R4313L_v_clip.cpg', 'r_R4313L_v_clip.dbf', 'r_R4313L_v_clip.prj', 'r_R4313L_v_clip.shp', 'r_R4313L_v_clip.shx', 's_R4311L_p_clip.cpg', 's_R4311L_p_clip.dbf', 's_R4311L_p_clip.prj', 's_R4311L_p_clip.shp', 's_R4311L_p_clip.shx', 's_R4311L_s_clip.cpg', 's_R4311L_s_clip.dbf', 's_R4311L_s_clip.prj', 's_R4311L_s_clip.shp', 's_R4311L_s_clip.shx', 's_R4311L_t_clip.cpg', 's_R4311L_t_clip.dbf', 's_R4311L_t_clip.prj', 's_R4311L_t_clip.shp', 's_R4311L_t_clip.shx', 's_R4311L_v_clip.cpg', 's_R4311L_v_clip.dbf', 's_R4311L_v_clip.prj', 's_R4311L_v_clip.shp', 's_R4311L_v_clip.shx']
listName = listName * 10
listOfPre= []
regex = re.compile(r"(.)_.*_(.)_clip.shp")

for i in listName:
	suf_pref= re.findall(regex, i)
	if len(suf_pref) != 0:
		listOfPre.append(suf_pref[0])




listOfPre = list(set(listOfPre))
print(listOfPre)

for prefix,suffix in listOfPre:
	print(f" {prefix}     {suffix}")
	regex2 = re.compile(f"({prefix})_.*_({suffix})_clip\.shp")

	for i in listName :
		if re.match(regex2,i):
			print(i)


