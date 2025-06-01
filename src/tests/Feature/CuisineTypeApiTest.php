<?php

declare(strict_types=1);

namespace Tests\Feature;

use App\Models\CuisineType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class CuisineTypeApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_cuisine_types(): void
    {
        CuisineType::factory()->createMany([
            ['name' => 'Italian'],
            ['name' => 'Mexican'],
        ]);

        $response = $this->getJson('/api/cuisine-types');

        $response->assertStatus(200)
            ->assertJsonFragments([
                ['name' => 'Italian'],
                ['name' => 'Mexican'],
            ]);
    }
}
