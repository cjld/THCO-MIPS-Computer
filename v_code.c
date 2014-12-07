
x,y,vx,vy;

if (reset) {
	x = 1;
	y = 1;
	vx = 1;
	vy = 1;
	b_pox = 0;
}
start:
{
	next_x = x + vx;
	next_y = y + vy;

	if check_men(next_x, next_y) 
		goto ok;

	vx = -vx;
	next_x = x + vx;

	if check_men(next_x, next_y) 
		goto ok;

	vy = -vy;
	next_y = y + vy;

	if check_men(next_x, next_y) 
		goto ok;

	vx = -vx;
	next_x = x + vx;

	if check_men(next_x, next_y) 
		goto ok;
}

if (x != 0) {
	erase(x,y);

	x = next_x;
	y = next_y;

	set(x,y);
}

erase_b(p_box);
if (press_l) p_box --;
if (press_r) p_box ++;
set(p_box);

goto start;

erase_b:
	for (int i=p_box; i<p_box+10; i++)
		erase(0,i);

print_b:
	for (int i=p_box; i<p_box+10; i++)
		set(0,i);

check_men:
	if (mem(x,y) != 0) {
		erase(x,y);
		return 0;
	}
mem:
	