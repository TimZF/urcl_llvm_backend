

struct Vec2{
    int x;
    int y;

    Vec2 operator+(const Vec2& rhs){
        return Vec2{this->x+rhs.x, this->y+rhs.y};
    }
};


int main(void)
{
    Vec2 a{1,2};
    //Vec2 b{2,3};

    //Vec2 c = a+b;
    return a.x;
}