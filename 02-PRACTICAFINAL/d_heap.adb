-----------------------------------------------------------------
-- implementación general del MAX-HEAP --
-----------------------------------------------------------------
package body d_heap is
procedure empty(q: out priority_queue) is
begin
	q.n:=0;
end empty;

procedure put(q: in out priority_queue; x:in item) is
	n: natural renames q.n;
	a: mem_space renames q.a;
	i, pi: natural;
begin
	if n=size then raise space_overflow; end if;
	n:=n+1; i:=n; pi:=n/2;
	while pi>0 and then a(pi)<x loop
		a(i):=a(pi); i:= pi; pi:=i/2;
	end loop;
	a(i):=x;
end put;

procedure delete_least(q: in out priority_queue) is
	n: natural renames q.n;
	a: mem_space renames q.a;
	x: item;
	i,ci: natural;
begin
	if n=0 then raise bad_use; end if;
	x:=a(n); n:=n-1;
	i:=1; ci:=i*2;
	if ci<n and then a(ci+1)>a(ci) then ci:= ci-1; end if;
	while ci<=n and then a(ci)>x loop
		a(i):=a(ci); i:=ci; ci:=i*2;
		if ci<n and then a(ci+1)>a(ci) then ci:= ci+1; end if;
	end loop;
	a(i):=x;
end delete_least;

function get_least(q: in priority_queue) return item is
begin
	if q.n=0 then raise bad_use; end if;
	return q.a(1);
end get_least;

function is_empty(q: in priority_queue) return boolean is
begin
	return q.n=0;
end is_empty;

function getn(q: in priority_queue) return integer is
begin
return q.n;
end getn;

function get(q:in priority_queue;i: in integer) return item is
begin
return q.a(i);
end get;

end d_heap;
